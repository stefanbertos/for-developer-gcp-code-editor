terraform {
  required_version = ">= 0.13"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.53"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.53"
    }
    template = {
      source = "hashicorp/template"
    }
    tls = {
      source = "hashicorp/tls"
    }
    namedotcom = {
      source = "registry.namedotcom.local/namedotcom/namedotcom"
    }
  }
}