output "ips" {
    value = { for ins in virtualbox_vm.ins : ins.name => format("int=%s", ins.network_adapter.*.ipv4_address) }
}
