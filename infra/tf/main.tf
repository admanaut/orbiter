provider "google" {
  version = "~> 3.24"
  credentials = var.gcp_credentials
  project = "orbiter-279306"
  region = "europe-west2"
}
