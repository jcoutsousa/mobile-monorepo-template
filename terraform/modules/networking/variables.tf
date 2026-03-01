variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "project_name" {
  description = "Human-readable project name for resource naming"
  type        = string
}

variable "region" {
  description = "GCP region for networking resources"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR range for the main subnet (e.g., '10.0.0.0/24')"
  type        = string
  default     = "10.0.0.0/24"
}

# --- Cloud NAT ---

variable "enable_nat" {
  description = "Enable Cloud NAT for outbound internet access from private resources"
  type        = bool
  default     = true
}

# --- Serverless VPC Connector ---

variable "enable_serverless_connector" {
  description = "Create a Serverless VPC Access connector for Cloud Run"
  type        = bool
  default     = true
}

variable "connector_cidr" {
  description = "CIDR range for the serverless VPC connector (must not overlap with subnet_cidr)"
  type        = string
  default     = "10.8.0.0/28"
}

variable "connector_min_instances" {
  description = "Minimum instances for the VPC connector"
  type        = number
  default     = 2
}

variable "connector_max_instances" {
  description = "Maximum instances for the VPC connector"
  type        = number
  default     = 3
}

variable "connector_min_throughput" {
  description = "Minimum throughput in Mbps for the VPC connector"
  type        = number
  default     = 200
}

variable "connector_max_throughput" {
  description = "Maximum throughput in Mbps for the VPC connector"
  type        = number
  default     = 300
}
