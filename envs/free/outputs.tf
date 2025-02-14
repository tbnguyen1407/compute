# output "module_aws_instance_ips" {
#   value = module.module_aws_instance[*].ips
# }

output "module_gcp_instance_ips" {
  value = module.module_gcp_instance[*].ips
}

output "module_oci_instance_amd_ips" {
  value = module.module_oci_instance_amd[*].ips
}

output "module_oci_instance_arm_ips" {
  value = module.module_oci_instance_arm[*].ips
}
