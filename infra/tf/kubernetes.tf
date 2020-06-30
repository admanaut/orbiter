resource "google_container_cluster" "primary_cluster" {
  name = "orbiter-gke-clustes"
  location = "europe-west2-c"

  // we want to use a separately managed node pool so let's
  // remove the default one that comes with the cluster.
  remove_default_node_pool = true
  initial_node_count = "1"

  master_auth {
    username = var.linux_admin_username
    password = var.linux_admin_password
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name = "orbiter-node-pool"
  location = "europe-west2-c"
  cluster = google_container_cluster.primary_cluster.name
  node_count = 1

  node_config {
    preemptible = true
    machine_type = "n1-standard-1"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
    ]
  }
}
