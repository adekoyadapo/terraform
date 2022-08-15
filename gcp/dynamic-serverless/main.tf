provider "google" {}

terraform {
  backend "local" {}
}

locals {
  domain  = "[domain]"  // Your Domain Name
  project = "[project]" // Your GCP project
  region  = "[region]"  // Your Region
  env     = "dev"       // Your environment

  // Backend Services
  services = [
    {
      "service" : "hello-world",
      "type" : "cloud_run",
      "path" : "/helloworld",
      "path_prefix_rewrite" : "/"
    },
    {
      "service" : "courses-api",
      "type" : "cloud_run",
      "path" : "/courses",
      "path_prefix_rewrite" : "/courses"
    },
    {
      "service" : "courses",
      "type" : "cloud_run",
      "path" : "/api",
      "path_prefix_rewrite" : "/api/courses"
    }
  ]
}


module "lb-http" {
  depends_on  = [tls_private_key.example, tls_self_signed_cert.example]
  source      = "GoogleCloudPlatform/lb-http/google//modules/serverless_negs"
  version     = "~> 6.1.1"
  name        = replace("${local.env}-${local.domain}", ".", "-")
  project     = local.project
  private_key = tls_private_key.example.private_key_pem
  certificate = tls_self_signed_cert.example.cert_pem
  ssl         = true
  #managed_ssl_certificate_domains = ["${local.env}.${local.domain}"]
  https_redirect = true
  create_url_map = false
  url_map        = google_compute_url_map.url-map.self_link

  backends = {
    for serviceObj in local.services :
    serviceObj.service => {
      description = serviceObj.service
      groups = [
        {
          group = google_compute_region_network_endpoint_group.neg[serviceObj.service].self_link
        }
      ]
      enable_cdn              = false
      security_policy         = null
      custom_request_headers  = null
      custom_response_headers = null
      timeout_sec             = 300

      iap_config = {
        enable               = false
        oauth2_client_id     = ""
        oauth2_client_secret = ""
      }
      log_config = {
        enable      = false
        sample_rate = null
      }
    }
  }
}

resource "google_compute_region_network_endpoint_group" "neg" {
  for_each              = { for service in local.services : "${service.service}" => service }
  name                  = replace("${each.value.service}-${local.env}", ".", "-")
  network_endpoint_type = "SERVERLESS"
  region                = local.region
  project               = local.project

  dynamic "app_engine" {
    for_each = each.value.type == "app_engine" ? [{ "service" : each.value.service }] : []
    content {
      service = app_engine.value.service
    }
  }

  dynamic "cloud_run" {
    for_each = each.value.type == "cloud_run" ? [{ "service" : each.value.service }] : []
    content {
      service = cloud_run.value.service
    }
  }

}

resource "google_compute_url_map" "url-map" {
  name        = replace("${local.env}-url-map", ".", "-")
  description = "{local.env}  url mapping for ${local.domain}"
  project     = local.project

  default_service = module.lb-http.backend_services["hello-world"].self_link

  host_rule {
    hosts        = ["${local.env}.${local.domain}"]
    path_matcher = "default"
  }
  path_matcher {
    name            = "default"
    default_service = module.lb-http.backend_services["hello-world"].self_link

    dynamic "path_rule" {
      for_each = local.services
      content {
        paths   = [path_rule.value.path]
        service = module.lb-http.backend_services[path_rule.value.service].self_link
        dynamic "route_action" {
          for_each = can(path_rule.value.path_prefix_rewrite) ? [{ "path_prefix_rewrite" : path_rule.value.path_prefix_rewrite }] : []
          content {
            url_rewrite {
              path_prefix_rewrite = route_action.value.path_prefix_rewrite
            }
          }
        }
      }
    }
  }
}