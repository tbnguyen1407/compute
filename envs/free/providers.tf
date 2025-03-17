#provider "aws" {
#  shared_config_files      = [pathexpand(var.provider_aws_config_file)]
#  shared_credentials_files = [pathexpand(var.provider_aws_credentials_file)]
#}

provider "google" {
  project     = var.provider_google_project
  zone        = var.provider_google_zone
  region      = var.provider_google_region
  credentials = var.provider_google_credentials_file
}

provider "oci" {
  tenancy_ocid     = var.provider_oci_tenancy_id
  user_ocid        = var.provider_oci_user_id
  region           = var.provider_oci_region
  private_key_path = pathexpand(var.provider_oci_private_key_path)
  fingerprint      = var.provider_oci_fingerprint
}
