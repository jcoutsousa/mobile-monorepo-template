variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region for secret replication"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "labels" {
  description = "Labels to apply to secrets"
  type        = map(string)
  default     = {}
}

variable "secrets" {
  description = "Map of secrets to create. Key is the secret_id."
  type = map(object({
    rotation_period  = optional(string, "")
    pubsub_topic     = optional(string, "")
    initial_value    = optional(string, "")
    accessor_members = optional(list(string), [])
  }))
  default = {}
}
