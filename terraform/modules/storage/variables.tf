variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "project_name" {
  description = "Human-readable project name for bucket naming"
  type        = string
}

variable "region" {
  description = "Default GCP region for bucket location"
  type        = string
}

variable "labels" {
  description = "Labels to apply to buckets"
  type        = map(string)
  default     = {}
}

variable "buckets" {
  description = "Map of GCS buckets to create. Key is appended to project_name for the bucket name."
  type = map(object({
    location            = optional(string, "")
    storage_class       = optional(string, "STANDARD")
    versioning          = optional(bool, false)
    public              = optional(bool, false)
    lifecycle_age_days  = optional(number, 0)
    max_versions        = optional(number, 5)
    nearline_after_days = optional(number, 0)
    iam_bindings = optional(list(object({
      role   = string
      member = string
    })), [])
  }))
  default = {}
}
