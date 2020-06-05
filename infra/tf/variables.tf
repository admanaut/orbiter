variable "gcp_credentials" {
  type = string
}

variable "linux_admin_urername" {
  type = string
}

variable "linux_admin_password" {
  type = string
}

output "gcp_cluster_endpoint" {
  value = "${google_container_cluster.primary_cluster.endpoint}"
}

output "gcp_ssh_commnad" {
  value = "ssh ${var.linux_admin_urername}@${google_container_cluster.primary_cluster.endpoint}"
}

output "gcp_cluster_name" {
  value = "${google_container_cluster.primary_cluster.name}"
}
