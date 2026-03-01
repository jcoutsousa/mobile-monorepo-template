variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "project_name" {
  description = "Human-readable project name for repository naming"
  type        = string
}

variable "region" {
  description = "GCP region for Artifact Registry"
  type        = string
}

variable "labels" {
  description = "Labels to apply to registries"
  type        = map(string)
  default     = {}
}

# --- Registry Toggles ---

variable "enable_docker" {
  description = "Create a Docker registry for container images"
  type        = bool
  default     = true
}

variable "enable_npm" {
  description = "Create an npm registry for React Native packages"
  type        = bool
  default     = false
}

variable "enable_python" {
  description = "Create a Python registry for backend packages"
  type        = bool
  default     = false
}

variable "enable_maven" {
  description = "Create a Maven registry for Kotlin/Java packages"
  type        = bool
  default     = false
}

variable "extra_registries" {
  description = "Additional registries beyond the built-in toggles"
  type = map(object({
    format      = string
    description = string
  }))
  default = {}
}

# --- Cleanup Policy ---

variable "cleanup_policy_enabled" {
  description = "Enable automatic cleanup of old artifacts"
  type        = bool
  default     = true
}

variable "cleanup_keep_count" {
  description = "Number of recent versions to keep per package"
  type        = number
  default     = 10
}

variable "cleanup_older_than" {
  description = "Delete artifacts older than this duration (e.g., '2592000s' for 30 days)"
  type        = string
  default     = "7776000s"
}
