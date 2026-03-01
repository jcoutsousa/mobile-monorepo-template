output "vpc_id" {
  description = "VPC network ID"
  value       = google_compute_network.vpc.id
}

output "vpc_name" {
  description = "VPC network name"
  value       = google_compute_network.vpc.name
}

output "subnet_id" {
  description = "Main subnet ID"
  value       = google_compute_subnetwork.main.id
}

output "subnet_name" {
  description = "Main subnet name"
  value       = google_compute_subnetwork.main.name
}

output "serverless_connector_id" {
  description = "Serverless VPC Access connector ID (empty if not enabled)"
  value       = length(google_vpc_access_connector.connector) > 0 ? google_vpc_access_connector.connector[0].id : ""
}

output "nat_ip" {
  description = "Cloud NAT external IP (empty if NAT not enabled)"
  value       = length(google_compute_router_nat.nat) > 0 ? google_compute_router_nat.nat[0].name : ""
}
