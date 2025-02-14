terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

## network
resource "google_compute_network" "net0" {
  ## required
  name = var.network_name

  ## optional
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet0" {
  ## required
  name    = var.subnet_name
  network = google_compute_network.net0.id

  ## optional
  ip_cidr_range = var.subnet_cidr_block
}
