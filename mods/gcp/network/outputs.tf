output "network_name" {
  value = google_compute_network.net0.self_link
}

output "subnet_name" {
  value = google_compute_subnetwork.subnet0.self_link
}
