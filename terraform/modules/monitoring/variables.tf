variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "project_name" {
  description = "Human-readable project name for display names"
  type        = string
}

# --- Notifications ---

variable "alert_emails" {
  description = "Email addresses for alert notifications"
  type        = list(string)
  default     = []
}

# --- Uptime Checks ---

variable "uptime_checks" {
  description = "Map of uptime check configurations"
  type = map(object({
    display_name          = string
    host                  = string
    path                  = string
    timeout               = optional(string, "10s")
    period                = optional(string, "300s")
    accepted_status_codes = optional(list(number), [200])
  }))
  default = {}
}

# --- Cloud Run Alerts ---

variable "enable_cloud_run_alerts" {
  description = "Enable Cloud Run error rate and latency alerts"
  type        = bool
  default     = true
}

variable "error_rate_threshold" {
  description = "5xx error rate threshold (requests/sec) that triggers an alert"
  type        = number
  default     = 1
}

variable "latency_threshold_ms" {
  description = "p99 latency threshold in milliseconds that triggers an alert"
  type        = number
  default     = 5000
}

# --- Dashboard ---

variable "enable_dashboard" {
  description = "Create a Cloud Monitoring dashboard for Cloud Run services"
  type        = bool
  default     = true
}
