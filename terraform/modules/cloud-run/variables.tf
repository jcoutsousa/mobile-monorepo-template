variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "project_name" {
  description = "Human-readable project name for resource naming"
  type        = string
}

variable "region" {
  description = "GCP region for Cloud Run services"
  type        = string
}

variable "services" {
  description = "Map of Cloud Run services to deploy. Key is the service identifier."
  type = map(object({
    image                  = string
    service_account_email  = string
    container_port         = optional(number, 8080)
    cpu                    = optional(string, "1")
    memory                 = optional(string, "512Mi")
    cpu_idle               = optional(bool, true)
    startup_cpu_boost      = optional(bool, true)
    min_instances          = optional(number, 0)
    max_instances          = optional(number, 10)
    request_timeout        = optional(string, "300s")
    health_check_path      = optional(string, "/health")
    allow_unauthenticated  = optional(bool, false)
    custom_domain          = optional(string, "")
    vpc_connector_id       = optional(string, "")
    env_vars               = optional(map(string), {})
    secret_env_vars = optional(map(object({
      secret_id = string
      version   = optional(string, "latest")
    })), {})
  }))
  default = {}
}
