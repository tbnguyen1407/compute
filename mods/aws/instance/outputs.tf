output "ips" {
  value = { for ins in aws_instance.ins : ins.id => format("int=%s ext=%s", ins.private_ip, ins.public_ip) }
}
