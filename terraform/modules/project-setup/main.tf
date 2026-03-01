# =============================================================================
# Project Setup Module — GCP APIs, billing budget
# =============================================================================

locals {
  # Core APIs required for a mobile monorepo with backend services
  required_apis = [
    "run.googleapis.com",
    "artifactregistry.googleapis.com",
    "secretmanager.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "sts.googleapis.com",
    "compute.googleapis.com",
    "vpcaccess.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudbilling.googleapis.com",
    "billingbudgets.googleapis.com",
    "serviceusage.googleapis.com",
  ]

  # Firebase APIs — enabled only when Firebase is used
  firebase_apis = var.enable_firebase ? [
    "firebase.googleapis.com",
    "firestore.googleapis.com",
    "firebaseappcheck.googleapis.com",
    "fcm.googleapis.com",
    "identitytoolkit.googleapis.com",
    "firebaseremoteconfig.googleapis.com",
    "crashlytics.googleapis.com",
    "firebaseappdistribution.googleapis.com",
  ] : []

  all_apis = concat(local.required_apis, local.firebase_apis, var.extra_apis)
}

resource "google_project_service" "apis" {
  for_each = toset(local.all_apis)

  project = var.project_id
  service = each.value

  disable_dependent_services = false
  disable_on_destroy         = false
}

# -----------------------------------------------------------------------------
# Billing Budget
# -----------------------------------------------------------------------------

data "google_billing_account" "account" {
  count = var.billing_account_id != "" ? 1 : 0

  billing_account = var.billing_account_id
}

resource "google_billing_budget" "environment" {
  count = var.billing_account_id != "" ? 1 : 0

  billing_account = var.billing_account_id
  display_name    = "${var.project_name}-${var.environment}-budget"

  budget_filter {
    projects = ["projects/${var.project_id}"]
  }

  amount {
    specified_amount {
      currency_code = var.budget_currency
      units         = tostring(var.budget_amount)
    }
  }

  dynamic "threshold_rules" {
    for_each = var.budget_alert_thresholds
    content {
      threshold_percent = threshold_rules.value
      spend_basis       = "CURRENT_SPEND"
    }
  }

  dynamic "all_updates_rule" {
    for_each = var.budget_alert_emails != [] ? [1] : []
    content {
      monitoring_notification_channels = []
      schema_version                   = "1.0"
    }
  }
}
