output "ips" {
  value = { for ins in google_compute_instance.ins : ins.name => format("int=%s ext=%s", ins.network_interface.0.network_ip, ins.network_interface.0.access_config.0.nat_ip) }
}
