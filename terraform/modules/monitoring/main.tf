# =============================================================================
# Monitoring Module — dashboards, alerting, uptime checks, error reporting
# =============================================================================

# -----------------------------------------------------------------------------
# Notification Channel (email)
# -----------------------------------------------------------------------------

resource "google_monitoring_notification_channel" "email" {
  for_each = toset(var.alert_emails)

  project      = var.project_id
  display_name = "Email: ${each.value}"
  type         = "email"

  labels = {
    email_address = each.value
  }
}

# -----------------------------------------------------------------------------
# Uptime Checks — for public-facing services
# -----------------------------------------------------------------------------

resource "google_monitoring_uptime_check_config" "checks" {
  for_each = var.uptime_checks

  project      = var.project_id
  display_name = each.value.display_name
  timeout      = each.value.timeout

  http_check {
    path           = each.value.path
    port           = 443
    use_ssl        = true
    validate_ssl   = true
    request_method = "GET"

    dynamic "accepted_response_status_codes" {
      for_each = each.value.accepted_status_codes
      content {
        status_value = accepted_response_status_codes.value
      }
    }
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = var.project_id
      host       = each.value.host
    }
  }

  period = each.value.period
}

# -----------------------------------------------------------------------------
# Alert Policies
# -----------------------------------------------------------------------------

# Cloud Run error rate alert
resource "google_monitoring_alert_policy" "cloud_run_errors" {
  count = var.enable_cloud_run_alerts ? 1 : 0

  project      = var.project_id
  display_name = "${var.project_name} — Cloud Run Error Rate"
  combiner     = "OR"

  conditions {
    display_name = "Cloud Run 5xx error rate"

    condition_threshold {
      filter          = "resource.type = \"cloud_run_revision\" AND metric.type = \"run.googleapis.com/request_count\" AND metric.labels.response_code_class = \"5xx\""
      comparison      = "COMPARISON_GT"
      threshold_value = var.error_rate_threshold
      duration        = "300s"

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }

  notification_channels = [for ch in google_monitoring_notification_channel.email : ch.id]

  alert_strategy {
    auto_close = "1800s"
  }
}

# Cloud Run latency alert
resource "google_monitoring_alert_policy" "cloud_run_latency" {
  count = var.enable_cloud_run_alerts ? 1 : 0

  project      = var.project_id
  display_name = "${var.project_name} — Cloud Run High Latency"
  combiner     = "OR"

  conditions {
    display_name = "Cloud Run p99 latency"

    condition_threshold {
      filter          = "resource.type = \"cloud_run_revision\" AND metric.type = \"run.googleapis.com/request_latencies\""
      comparison      = "COMPARISON_GT"
      threshold_value = var.latency_threshold_ms
      duration        = "300s"

      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_PERCENTILE_99"
      }
    }
  }

  notification_channels = [for ch in google_monitoring_notification_channel.email : ch.id]

  alert_strategy {
    auto_close = "1800s"
  }
}

# Uptime check failure alert
resource "google_monitoring_alert_policy" "uptime_failure" {
  for_each = var.uptime_checks

  project      = var.project_id
  display_name = "${var.project_name} — Uptime: ${each.value.display_name}"
  combiner     = "OR"

  conditions {
    display_name = "Uptime check failure for ${each.value.display_name}"

    condition_threshold {
      filter          = "resource.type = \"uptime_url\" AND metric.type = \"monitoring.googleapis.com/uptime_check/check_passed\" AND metric.labels.check_id = \"${google_monitoring_uptime_check_config.checks[each.key].uptime_check_id}\""
      comparison      = "COMPARISON_GT"
      threshold_value = 1
      duration        = "300s"

      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_COUNT_FALSE"
        cross_series_reducer = "REDUCE_COUNT"
      }
    }
  }

  notification_channels = [for ch in google_monitoring_notification_channel.email : ch.id]

  alert_strategy {
    auto_close = "1800s"
  }
}

# -----------------------------------------------------------------------------
# Dashboard — Cloud Run overview
# -----------------------------------------------------------------------------

resource "google_monitoring_dashboard" "cloud_run" {
  count = var.enable_dashboard ? 1 : 0

  project        = var.project_id
  dashboard_json = jsonencode({
    displayName = "${var.project_name} — Cloud Run Overview"
    gridLayout = {
      columns = 2
      widgets = [
        {
          title = "Request Count"
          xyChart = {
            dataSets = [{
              timeSeriesQuery = {
                timeSeriesFilter = {
                  filter = "resource.type = \"cloud_run_revision\" AND metric.type = \"run.googleapis.com/request_count\""
                  aggregation = {
                    alignmentPeriod  = "60s"
                    perSeriesAligner = "ALIGN_RATE"
                  }
                }
              }
            }]
          }
        },
        {
          title = "Request Latency (p50, p95, p99)"
          xyChart = {
            dataSets = [{
              timeSeriesQuery = {
                timeSeriesFilter = {
                  filter = "resource.type = \"cloud_run_revision\" AND metric.type = \"run.googleapis.com/request_latencies\""
                  aggregation = {
                    alignmentPeriod  = "60s"
                    perSeriesAligner = "ALIGN_PERCENTILE_99"
                  }
                }
              }
            }]
          }
        },
        {
          title = "Instance Count"
          xyChart = {
            dataSets = [{
              timeSeriesQuery = {
                timeSeriesFilter = {
                  filter = "resource.type = \"cloud_run_revision\" AND metric.type = \"run.googleapis.com/container/instance_count\""
                  aggregation = {
                    alignmentPeriod  = "60s"
                    perSeriesAligner = "ALIGN_MEAN"
                  }
                }
              }
            }]
          }
        },
        {
          title = "Memory Utilization"
          xyChart = {
            dataSets = [{
              timeSeriesQuery = {
                timeSeriesFilter = {
                  filter = "resource.type = \"cloud_run_revision\" AND metric.type = \"run.googleapis.com/container/memory/utilizations\""
                  aggregation = {
                    alignmentPeriod  = "60s"
                    perSeriesAligner = "ALIGN_PERCENTILE_99"
                  }
                }
              }
            }]
          }
        },
      ]
    }
  })
}
