# VPC
resource "digitalocean_vpc" "this" {
  name   = "${var.prefix}-${var.environment}-${var.region}-k8s-vpc"
  region = var.region
}

