provider "google" {
  project = var.project
}

provider "google-beta" {
  project = var.project
}

resource "google_compute_network" "default" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  name                     = var.network_name
  ip_cidr_range            = "10.127.0.0/20"
  network                  = google_compute_network.default.self_link
  region                   = var.region
  private_ip_google_access = true
}

resource "google_compute_router" "default" {
  name    = "code-editor-router"
  network = google_compute_network.default.self_link
  region  = var.region
}

module "cloud-nat" {
  source     = "terraform-google-modules/cloud-nat/google"
  version    = "1.4.0"
  router     = google_compute_router.default.name
  project_id = var.project
  region     = var.region
  name       = "code-editor-nat"
}

data "template_file" "instance-startup-script" {
  template = file(format("%s/gceme.sh.tpl", path.module))

  vars = {
    PROXY_PATH = ""
  }
}

module "mig_template" {
  source     = "terraform-google-modules/vm/google//modules/instance_template"
  version    = "6.2.0"
  network    = google_compute_network.default.self_link
  subnetwork = google_compute_subnetwork.default.self_link
  service_account = {
    email  = ""
    scopes = ["cloud-platform"]
  }
  name_prefix    = "code-editor-instance-template"
  startup_script = data.template_file.instance-startup-script.rendered
  source_image_family  = "ubuntu-2004-lts"
  source_image_project = "ubuntu-os-cloud"
  tags = [
    var.network_name,
    module.cloud-nat.router_name
  ]
  disk_size_gb = 20
  disk_type = "pd-ssd"
  machine_type = "e2-medium"
  metadata = {
      serial-port-enable = "FALSE"
  }
}

module "mig" {
  source            = "terraform-google-modules/vm/google//modules/mig"
  version           = "6.2.0"
  instance_template = module.mig_template.self_link
  region            = var.region
  hostname          = var.network_name
  mig_name              = "code-editor-instance-group"
  target_size       = 1
  named_ports = [{
    name = "http",
    port = 80
  }]
  network    = google_compute_network.default.self_link
  subnetwork = google_compute_subnetwork.default.self_link
}

resource "google_compute_managed_ssl_certificate" "default" {
  name = "code-editor-cert"

  managed {
    domains = [var.domain_name]
  }
}

module "gce-lb-http" {
  source               = "GoogleCloudPlatform/lb-http/google"
  version              = "~> 5.1"
  name                 = "code-editor-https-load-balancer"
  project              = var.project
  target_tags          = [var.network_name]
  firewall_networks    = [google_compute_network.default.name]
  ssl                  = true
  ssl_certificates     = [google_compute_managed_ssl_certificate.default.self_link]
  use_ssl_certificates = true
  https_redirect       = true

  backends = {
    default = {
      description                     = null
      protocol                        = "HTTP"
      port                            = 80
      port_name                       = "http"
      timeout_sec                     = 300
      connection_draining_timeout_sec = null
      enable_cdn                      = false
      security_policy                 = null
      session_affinity                = null
      affinity_cookie_ttl_sec         = null
      custom_request_headers          = null
      custom_response_headers         = null

      health_check = {
        check_interval_sec  = 300
        timeout_sec         = 300
        healthy_threshold   = 1
        unhealthy_threshold = 5
        request_path        = "/healthz"
        port                = 80
        host                = null
        logging             = true
      }

      log_config = {
        enable      = true
        sample_rate = 1.0
      }

      groups = [
        {
          group                        = module.mig.instance_group
          balancing_mode               = "UTILIZATION"
          capacity_scaler              = 1.0
          description                  = null
          max_connections              = null
          max_connections_per_instance = null
          max_connections_per_endpoint = null
          max_rate                     = null
          max_rate_per_instance        = null
          max_rate_per_endpoint        = null
          max_utilization              = null
        }
      ]
      iap_config = {
        enable               = false
        oauth2_client_id     = ""
        oauth2_client_secret = ""
      }
    }
  }
}

provider "namedotcom" {
  token = var.name_com_token
  username = var.name_com_username
}

resource "namedotcom_record" "foo" {
  domain_name = var.domain_name
  record_type = "A"
  answer = module.gce-lb-http.external_ip
}
#manual stuff - enable iap for external users which is not possible via terraform