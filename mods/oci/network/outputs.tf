output "compartment_id" {
  value = oci_identity_compartment.cpt0.id
}

output "network_id" {
  value = oci_core_vcn.net0.id
}

output "subnet_id" {
  value = oci_core_subnet.subnet0.id
}
