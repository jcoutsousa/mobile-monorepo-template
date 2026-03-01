variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

# --- App Definitions ---

variable "android_apps" {
  description = "Map of Android apps to register in Firebase. Key is a unique identifier."
  type = map(object({
    display_name = string
    package_name = string
  }))
  default = {}
}

variable "ios_apps" {
  description = "Map of iOS apps to register in Firebase. Key is a unique identifier."
  type = map(object({
    display_name = string
    bundle_id    = string
    app_store_id = optional(string)
  }))
  default = {}
}

variable "web_apps" {
  description = "Map of web apps to register in Firebase. Key is a unique identifier."
  type = map(object({
    display_name = string
  }))
  default = {}
}

# --- Firestore ---

variable "enable_firestore" {
  description = "Create a Firestore database"
  type        = bool
  default     = true
}

variable "firestore_location" {
  description = "Firestore database location (e.g., 'eur3' for Europe multi-region, 'europe-west1' for single region)"
  type        = string
  default     = "eur3"
}

# --- Authentication ---

variable "enable_auth" {
  description = "Enable Firebase Authentication (Identity Platform)"
  type        = bool
  default     = true
}

variable "auth_email_enabled" {
  description = "Enable email/password sign-in provider"
  type        = bool
  default     = true
}

variable "auth_password_required" {
  description = "Require password for email sign-in (false allows passwordless/magic link)"
  type        = bool
  default     = true
}

variable "auth_anonymous_enabled" {
  description = "Enable anonymous sign-in provider"
  type        = bool
  default     = false
}
