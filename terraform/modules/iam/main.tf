# =============================================================================
# IAM Module — Service Accounts + Workload Identity Federation
# =============================================================================
# WIF allows GitHub Actions to authenticate to GCP without service account keys.
# This is the recommended approach — SA keys are a security risk.

# -----------------------------------------------------------------------------
# Service Accounts
# -----------------------------------------------------------------------------

resource "google_service_account" "accounts" {
  for_each = var.service_accounts

  project      = var.project_id
  account_id   = each.key
  display_name = each.value.display_name
  description  = each.value.description
}

# IAM role bindings for each service account
resource "google_project_iam_member" "sa_roles" {
  for_each = { for binding in local.sa_role_bindings : "${binding.sa_key}-${binding.role}" => binding }

  project = var.project_id
  role    = each.value.role
  member  = "serviceAccount:${google_service_account.accounts[each.value.sa_key].email}"
}

locals {
  sa_role_bindings = flatten([
    for sa_key, sa in var.service_accounts : [
      for role in sa.roles : {
        sa_key = sa_key
        role   = role
      }
    ]
  ])
}

# -----------------------------------------------------------------------------
# Workload Identity Federation — GitHub Actions → GCP (keyless auth)
# -----------------------------------------------------------------------------

resource "google_iam_workload_identity_pool" "github" {
  count = var.enable_wif ? 1 : 0

  project                   = var.project_id
  workload_identity_pool_id = "${var.project_name}-github-pool"
  display_name              = "GitHub Actions Pool"
  description               = "WIF pool for GitHub Actions CI/CD"
}

resource "google_iam_workload_identity_pool_provider" "github" {
  count = var.enable_wif ? 1 : 0

  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github[0].workload_identity_pool_id
  workload_identity_pool_provider_id = "github-provider"
  display_name                       = "GitHub Actions OIDC"
  description                        = "OIDC provider for GitHub Actions"

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.repository" = "assertion.repository"
    "attribute.ref"        = "assertion.ref"
  }

  attribute_condition = "assertion.repository == '${var.github_repository}'"

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

# Allow the GitHub Actions SA to be impersonated via WIF
resource "google_service_account_iam_member" "wif_binding" {
  for_each = var.enable_wif ? var.wif_service_account_bindings : {}

  service_account_id = google_service_account.accounts[each.value.service_account_key].name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github[0].name}/attribute.repository/${var.github_repository}"
}

# Optional: restrict WIF to specific branches
resource "google_service_account_iam_member" "wif_branch_binding" {
  for_each = var.enable_wif ? var.wif_branch_restrictions : {}

  service_account_id = google_service_account.accounts[each.value.service_account_key].name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github[0].name}/attribute.ref/refs/heads/${each.value.branch}"
}
