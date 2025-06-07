terraform {
  required_providers {
    #aws = {
    #  source  = "hashicorp/aws"
    #  version = "5.96.0"
    #}
    google = {
      source  = "hashicorp/google"
      version = "6.38.0"
    }
    oci = {
      source  = "oracle/oci"
      version = "7.4.0"
    }
  }
}

## aws
# module "module_aws_network" {
#   source = "../../mods/aws/network"
# }

# module "module_aws_security" {
#   source = "../../mods/aws/security"

#   ## required
#   network_id = module.module_aws_network.network_id

#   ## optional
#   rules = var.security_rules
# }

# module "module_aws_instance" {
#   source = "../../mods/aws/instance"

#   ## required
#   network_id = module.module_aws_network.network_id
#   subnet_id  = module.module_aws_network.subnet_id

#   ## optional
#   instance_count = 1
#   instance_shape = {
#     type = "t4g.small"
#   }
#   instance_bootdisk = {
#     image = "ami-023d6c5b3a28a2d1d"
#     type  = "gp3"
#     size  = 30
#   }
#   security_group_ids  = [module.module_aws_security.security_group_id]
#   ssh_authorized_keys = var.ssh_authorized_keys
# }

## gcp
module "module_gcp_network" {
  source = "../../mods/gcp/network"
}

module "module_gcp_security" {
  source = "../../mods/gcp/security"

  ## required
  network_name = module.module_gcp_network.network_name

  ## optional
  rules = var.security_rules
}

module "module_gcp_instance" {
  source = "../../mods/gcp/instance"

  ## required
  subnet_name = module.module_gcp_network.subnet_name

  ## optional
  instance_count = 1
  instance_shape = {
    type = "e2-micro"
  }
  instance_bootdisk = {
    image = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
    type  = "pd-standard"
    size  = 28
  }
  instance_network_tags = [for rule in var.security_rules : rule.name]
  ssh_authorized_keys   = var.ssh_authorized_keys
}

## oci
module "module_oci_network" {
  source = "../../mods/oci/network"

  ## required
  tenancy_id = var.provider_oci_tenancy_id
}

module "module_oci_security" {
  source = "../../mods/oci/security"

  ## required
  compartment_id = module.module_oci_network.compartment_id
  network_id     = module.module_oci_network.network_id

  ## optional
  rules = var.security_rules
}

module "module_oci_instance_amd" {
  source = "../../mods/oci/instance"

  ## required
  compartment_id = module.module_oci_network.compartment_id
  network_id     = module.module_oci_network.network_id
  subnet_id      = module.module_oci_network.subnet_id

  ## optional
  availability_domain  = var.provider_oci_availability_domain
  instance_count       = 2
  instance_name_prefix = "amd"
  instance_shape = {
    type = "VM.Standard.E2.1.Micro"
    cpu  = 1
    ram  = 1
  }
  instance_bootdisk = {
    image = "ocid1.image.oc1.ap-singapore-1.aaaaaaaaiyq36wrtjisfxsrbikhdgmvflpdc7yyjuqj4io6q4opunnytphxq"
    size  = 50
  }
  security_group_ids  = [module.module_oci_security.security_group_id]
  ssh_authorized_keys = var.ssh_authorized_keys
}

module "module_oci_instance_arm" {
  source = "../../mods/oci/instance"

  ## required
  compartment_id = module.module_oci_network.compartment_id
  network_id     = module.module_oci_network.network_id
  subnet_id      = module.module_oci_network.subnet_id

  ## optional
  availability_domain  = var.provider_oci_availability_domain
  instance_count       = 2
  instance_name_prefix = "arm"
  instance_shape = {
    type = "VM.Standard.A1.Flex"
    cpu  = 2
    ram  = 12
  }
  instance_bootdisk = {
    image = "ocid1.image.oc1.ap-singapore-1.aaaaaaaanwjetwn6ubol5lq2xvmwvglv6l26ad6lck4esnmlraawg4wderka" ## Oracle Linux 9.5 (aarch)
    size  = 50
  }
  security_group_ids  = [module.module_oci_security.security_group_id]
  ssh_authorized_keys = var.ssh_authorized_keys
}
