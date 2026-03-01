variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "project_name" {
  description = "Human-readable project name"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "enable_firebase" {
  description = "Enable Firebase-related APIs"
  type        = bool
  default     = true
}

variable "extra_apis" {
  description = "Additional GCP APIs to enable beyond the defaults"
  type        = list(string)
  default     = []
}

variable "billing_account_id" {
  description = "GCP billing account ID (format: XXXXXX-XXXXXX-XXXXXX). Leave empty to skip budget creation."
  type        = string
  default     = ""
}

variable "budget_amount" {
  description = "Monthly budget amount in the specified currency"
  type        = number
  default     = 100
}

variable "budget_currency" {
  description = "Budget currency code (e.g., EUR, USD)"
  type        = string
  default     = "EUR"
}

variable "budget_alert_thresholds" {
  description = "List of threshold percentages (0.0-1.0) at which to trigger budget alerts"
  type        = list(number)
  default     = [0.5, 0.8, 0.9, 1.0]
}

variable "budget_alert_emails" {
  description = "Email addresses to notify when budget thresholds are reached"
  type        = list(string)
  default     = []
}
