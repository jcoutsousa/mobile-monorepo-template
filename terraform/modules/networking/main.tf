# =============================================================================
# Networking Module — VPC, subnets, Cloud NAT, Serverless VPC Connector
# =============================================================================

# -----------------------------------------------------------------------------
# VPC Network
# -----------------------------------------------------------------------------

resource "google_compute_network" "vpc" {
  name                    = "${var.project_name}-vpc"
  project                 = var.project_id
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

# -----------------------------------------------------------------------------
# Subnet
# -----------------------------------------------------------------------------

resource "google_compute_subnetwork" "main" {
  name                     = "${var.project_name}-subnet-${var.region}"
  project                  = var.project_id
  region                   = var.region
  network                  = google_compute_network.vpc.id
  ip_cidr_range            = var.subnet_cidr
  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

# -----------------------------------------------------------------------------
# Cloud Router + NAT — outbound internet for private resources
# -----------------------------------------------------------------------------

resource "google_compute_router" "router" {
  count = var.enable_nat ? 1 : 0

  name    = "${var.project_name}-router"
  project = var.project_id
  region  = var.region
  network = google_compute_network.vpc.id
}

resource "google_compute_router_nat" "nat" {
  count = var.enable_nat ? 1 : 0

  name                               = "${var.project_name}-nat"
  project                            = var.project_id
  region                             = var.region
  router                             = google_compute_router.router[0].name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

# -----------------------------------------------------------------------------
# Serverless VPC Access Connector — for Cloud Run → VPC
# -----------------------------------------------------------------------------

resource "google_vpc_access_connector" "connector" {
  count = var.enable_serverless_connector ? 1 : 0

  name          = "${var.project_name}-connector"
  project       = var.project_id
  region        = var.region
  ip_cidr_range = var.connector_cidr
  network       = google_compute_network.vpc.id

  min_instances = var.connector_min_instances
  max_instances = var.connector_max_instances

  min_throughput = var.connector_min_throughput
  max_throughput = var.connector_max_throughput
}

# -----------------------------------------------------------------------------
# Firewall — allow internal traffic
# -----------------------------------------------------------------------------

resource "google_compute_firewall" "allow_internal" {
  name    = "${var.project_name}-allow-internal"
  project = var.project_id
  network = google_compute_network.vpc.id

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = [var.subnet_cidr, var.connector_cidr]
}
