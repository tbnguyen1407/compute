## aws provider
#variable "provider_aws_config_file" {}
#variable "provider_aws_credentials_file" {}

## google provider
variable "provider_google_project" {}
variable "provider_google_region" {}
variable "provider_google_zone" {}
variable "provider_google_credentials_file" {}

## oci provider
variable "provider_oci_tenancy_id" {}
variable "provider_oci_user_id" {}
variable "provider_oci_region" {}
variable "provider_oci_availability_domain" {}
variable "provider_oci_private_key_path" {}
variable "provider_oci_fingerprint" {}

## shared
variable "ssh_authorized_keys" {
  type = map(string)
}

variable "security_rules" {
  type = list(object({
    name      = string
    direction = optional(string, "INGRESS")
    protocol  = optional(string, "TCP")
    src       = optional(string, "0.0.0.0/0")
    src_port  = optional(string)
    dst       = optional(string, "0.0.0.0/0")
    dst_port  = optional(string)
  }))
  default = []
}
