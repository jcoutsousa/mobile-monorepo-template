# =============================================================================
# Global Variables — shared across all environments
# =============================================================================

variable "project_id" {
  description = "GCP project ID (e.g., 'my-app-dev-123456')"
  type        = string
}

variable "region" {
  description = "Default GCP region for resources (e.g., 'europe-west1')"
  type        = string
  default     = "europe-west1"
}

variable "environment" {
  description = "Environment name: dev, staging, or prod"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "project_name" {
  description = "Human-readable project name (used in resource naming, e.g., 'my-app')"
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,28}[a-z0-9]$", var.project_name))
    error_message = "Project name must be lowercase alphanumeric with hyphens, 3-30 chars."
  }
}

variable "labels" {
  description = "Default labels applied to all resources"
  type        = map(string)
  default     = {}
}
