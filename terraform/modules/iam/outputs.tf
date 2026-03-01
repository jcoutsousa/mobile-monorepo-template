output "service_account_emails" {
  description = "Map of service account keys to their email addresses"
  value       = { for k, v in google_service_account.accounts : k => v.email }
}

output "service_account_ids" {
  description = "Map of service account keys to their unique IDs"
  value       = { for k, v in google_service_account.accounts : k => v.unique_id }
}

output "wif_pool_name" {
  description = "Workload Identity Federation pool name (for GitHub Actions auth)"
  value       = var.enable_wif ? google_iam_workload_identity_pool.github[0].name : ""
}

output "wif_provider_name" {
  description = "Workload Identity Federation provider name (for GitHub Actions auth)"
  value       = var.enable_wif ? google_iam_workload_identity_pool_provider.github[0].name : ""
}

output "github_actions_auth_config" {
  description = "Configuration values needed in GitHub Actions workflows for WIF auth"
  value = var.enable_wif ? {
    workload_identity_provider = google_iam_workload_identity_pool_provider.github[0].name
    # Usage in GitHub Actions:
    # - uses: google-github-actions/auth@v2
    #   with:
    #     workload_identity_provider: ${{ secrets.WIF_PROVIDER }}
    #     service_account: ${{ secrets.GCP_SERVICE_ACCOUNT }}
  } : {}
}
