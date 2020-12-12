# Kubernetes Cluster
resource "digitalocean_kubernetes_cluster" "this" {
  depends_on = [digitalocean_vpc.this]

  name         = "${var.prefix}-${var.environment}-${var.region}-k8s-cluster"
  region       = var.region
  version      = var.kubernetes_version
  vpc_uuid     = digitalocean_vpc.this.id
  auto_upgrade = var.kubernetes_auto_upgrade

  node_pool {
    name       = "worker-pool"
    size       = var.kubernetes_node_pool_nodes_size
    auto_scale = true
    min_nodes  = var.kubernetes_node_pool_nodes_min
    max_nodes  = var.kubernetes_node_pool_nodes_max
  }
}