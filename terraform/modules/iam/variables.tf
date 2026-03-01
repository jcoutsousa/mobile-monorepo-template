variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "project_name" {
  description = "Human-readable project name"
  type        = string
}

# --- Service Accounts ---

variable "service_accounts" {
  description = "Map of service accounts to create. Key is the account_id (e.g., 'github-actions-sa')."
  type = map(object({
    display_name = string
    description  = string
    roles        = list(string)
  }))
  default = {}
}

# --- Workload Identity Federation ---

variable "enable_wif" {
  description = "Enable Workload Identity Federation for GitHub Actions (keyless auth)"
  type        = bool
  default     = true
}

variable "github_repository" {
  description = "GitHub repository in 'owner/repo' format (used for WIF attribute condition)"
  type        = string
  default     = ""
}

variable "wif_service_account_bindings" {
  description = "Map of WIF bindings: which SAs can be impersonated by any branch in the repo"
  type = map(object({
    service_account_key = string
  }))
  default = {}
}

variable "wif_branch_restrictions" {
  description = "Optional branch-level WIF restrictions (e.g., only main can deploy to prod)"
  type = map(object({
    service_account_key = string
    branch              = string
  }))
  default = {}
}
