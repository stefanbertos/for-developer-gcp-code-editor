output "load-balancer-ip" {
  value = module.gce-lb-http.external_ip
}

output "load-balancer-ipv6" {
  value       = module.gce-lb-http.ipv6_enabled ? module.gce-lb-http.external_ipv6_address : "undefined"
  description = "The IPv6 address of the load-balancer, if enabled; else \"undefined\""
}

output "backend_services" {
  sensitive = true
  value     = module.gce-lb-http.backend_services
}

output "certificate-id" {
  value = google_compute_managed_ssl_certificate.default.certificate_id
}

output "certificate-cn" {
  value = google_compute_managed_ssl_certificate.default.subject_alternative_names
}

output "certificate-expire-time" {
  value = google_compute_managed_ssl_certificate.default.expire_time
}


