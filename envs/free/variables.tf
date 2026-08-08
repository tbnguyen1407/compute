## oci provider
variable "provider_oci_tenancy_id" {}
variable "provider_oci_availability_domain" {}

## shared
variable "ssh_authorized_keys" {
  type = map(string)
  default = {}
}

