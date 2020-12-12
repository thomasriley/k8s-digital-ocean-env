# Terraform Backend Bucket
resource "digitalocean_spaces_bucket" "terraform_backend" {
  name   = "${var.prefix}-${var.environment}-${var.region}-k8s-terraform-backend"
  region = var.region
}

# Terraform Backend Configuration
terraform {
  backend "s3" {
    endpoint                    = "region.digitaloceanspaces.com"
    key = "terraform.tfstate"
    bucket                      = "bucket-name"
    region                      = "us-west-1"
    skip_requesting_account_id  = true
    skip_credentials_validation = true
    skip_get_ec2_platforms      = true
    skip_metadata_api_check     = true
  }
}