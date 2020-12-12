variable "prefix" {
  type        = string
  description = "A prefix name to apply to all resources managed via Terraform."
  default     = "do"
}

variable "environment" {
  type        = string
  description = "The environment name to use, for example: 'sandbox', 'development' or 'production'."
  default     = "sandbox"
}

variable "region" {
  type        = string
  description = "The DigitalOcean region slug for the location to launch resources (https://www.digitalocean.com/docs/platform/availability-matrix/)."
  default     = "ams3"
}

variable "vpc_ip_range" {
  type        = string
  description = "The range of IP addresses for the VPC in CIDR notation. Network ranges cannot overlap with other networks in the same account and must be in range of private addresses as defined in RFC1918. It may not be larger than /16 or smaller than /24."
  default     = "172.16.0.0/21"
}

variable "kubernetes_version" {
  type        = string
  description = "The Digital Ocean Managed Kubernetes version slug use. To see available versions run `doctl kubernetes options versions`"
  default     = "1.19.3-do.2"
}

variable "kubernetes_auto_upgrade" {
  type        = bool
  description = "A boolean value indicating whether the cluster will be automatically upgraded to new patch releases during its maintenance window."
  default     = false
}

variable "kubernetes_node_pool_nodes_size" {
  type        = string
  description = "The Droplet size to use for the Kubernetes Node Pool"
  default     = "s-2vcpu-2gb"
}

variable "kubernetes_node_pool_nodes_min" {
  type        = string
  description = "The minimum number of nodes in the Kubernetes Node Pool"
  default     = 2
}

variable "kubernetes_node_pool_nodes_max" {
  type        = string
  description = "The maximum number of nodes in the Kubernetes Node Pool"
  default     = 4
}
