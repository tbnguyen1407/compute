output "ips" {
  value = { for ins in oci_core_instance.ins : ins.display_name => format("int=%s ext=%s", ins.private_ip, ins.public_ip) }
}
