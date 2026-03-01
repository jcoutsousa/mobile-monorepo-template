# =============================================================================
# Prod Environment Variables — same as dev/staging but with HA defaults
# =============================================================================

variable "project_id" {
  description = "GCP project ID for the production environment"
  type        = string
}

variable "project_name" {
  description = "Human-readable project name (e.g., 'my-app')"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "europe-west1"
}

variable "labels" {
  description = "Additional labels for all resources"
  type        = map(string)
  default     = {}
}

variable "enable_firebase" {
  description = "Enable Firebase module"
  type        = bool
  default     = true
}

variable "enable_wif" {
  description = "Enable Workload Identity Federation for GitHub Actions"
  type        = bool
  default     = true
}

variable "github_repository" {
  description = "GitHub repo in 'owner/repo' format for WIF"
  type        = string
  default     = ""
}

variable "enable_npm_registry" {
  description = "Create npm Artifact Registry"
  type        = bool
  default     = false
}

variable "enable_python_registry" {
  description = "Create Python Artifact Registry"
  type        = bool
  default     = false
}

variable "enable_maven_registry" {
  description = "Create Maven Artifact Registry"
  type        = bool
  default     = false
}

variable "billing_account_id" {
  description = "GCP billing account ID"
  type        = string
  default     = ""
}

variable "budget_amount" {
  description = "Monthly budget amount in EUR (production should be higher)"
  type        = number
  default     = 500
}

variable "android_apps" {
  description = "Android apps to register in Firebase"
  type = map(object({
    display_name = string
    package_name = string
  }))
  default = {}
}

variable "ios_apps" {
  description = "iOS apps to register in Firebase"
  type = map(object({
    display_name = string
    bundle_id    = string
    app_store_id = optional(string)
  }))
  default = {}
}

variable "web_apps" {
  description = "Web apps to register in Firebase"
  type = map(object({
    display_name = string
  }))
  default = {}
}

variable "cloud_run_services" {
  description = "Map of Cloud Run services to deploy (production defaults: min_instances=1, max=20)"
  type = map(object({
    image                 = string
    container_port        = optional(number, 8080)
    cpu                   = optional(string, "2")
    memory                = optional(string, "1Gi")
    min_instances         = optional(number, 1)
    max_instances         = optional(number, 20)
    health_check_path     = optional(string, "/health")
    allow_unauthenticated = optional(bool, false)
    custom_domain         = optional(string, "")
    env_vars              = optional(map(string), {})
    secret_env_vars = optional(map(object({
      secret_id = string
      version   = optional(string, "latest")
    })), {})
  }))
  default = {}
}

variable "secrets" {
  description = "Secrets to create in Secret Manager"
  type = map(object({
    rotation_period  = optional(string, "")
    pubsub_topic     = optional(string, "")
    initial_value    = optional(string, "")
    accessor_members = optional(list(string), [])
  }))
  default = {}
}

variable "alert_emails" {
  description = "Email addresses for alert notifications (required for production)"
  type        = list(string)
}

variable "uptime_checks" {
  description = "Uptime check configurations"
  type = map(object({
    display_name          = string
    host                  = string
    path                  = string
    timeout               = optional(string, "10s")
    period                = optional(string, "60s")
    accepted_status_codes = optional(list(number), [200])
  }))
  default = {}
}
