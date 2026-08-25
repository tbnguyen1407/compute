terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.45.0"
    }
    oci = {
      source  = "oracle/oci"
      version = "8.28.0"
    }
  }
}

provider "google" {
  project = "prj0-443107"
}

provider "oci" {
}

## gcp
module "module_gcp_network" {
  source = "../../mods/gcp/network"
}

module "module_gcp_security" {
  source = "../../mods/gcp/security"

  ## required
  network_name = module.module_gcp_network.network_name

  ## optional
  ingress_rules = {
    "ingress-allow-ssh" = {
      src      = "0.0.0.0/0"
      dst      = module.module_gcp_network.subnet_cidr
      port     = 22
      protocol = "TCP"
    }
    "ingress-allow-icmp" = {
      src      = "0.0.0.0/0"
      dst      = module.module_gcp_network.subnet_cidr
      protocol = "ICMP"
    }
  }
  egress_rules = {
    "egress-allow-all" = {
      src      = module.module_gcp_network.subnet_cidr
      dst      = "0.0.0.0/0"
      protocol = "ALL"
    }
  }
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
  ssh_authorized_keys = var.ssh_authorized_keys
}

## oci
module "module_oci_network" {
  source = "../../mods/oci/network"

  ## required
  tenancy_id = var.provider_oci_tenancy_id

  ## optional
  network_cidr_blocks = ["10.0.0.0/16"]
  subnet_cidr_block   = "10.0.1.0/24"
}

module "module_oci_security" {
  source = "../../mods/oci/security"

  ## required
  compartment_id = module.module_oci_network.compartment_id
  network_id     = module.module_oci_network.network_id

  ## optional
  ingress_rules = {
    "ingress-allow-ssh" = {
      src      = "0.0.0.0/0"
      port     = 22
      protocol = "TCP"
    }
    "ingress-allow-icmp" = {
      src      = "0.0.0.0/0"
      protocol = "ICMP"
    }
  }
  egress_rules = {
    "egress-allow-all" = {
      dst      = "0.0.0.0/0"
      protocol = "ALL"
    }
  }
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
    cpu  = 1
    ram  = 6
  }
  instance_bootdisk = {
    image = "ocid1.image.oc1.ap-singapore-1.aaaaaaaanwjetwn6ubol5lq2xvmwvglv6l26ad6lck4esnmlraawg4wderka" ## Oracle Linux 9.5 (aarch)
    size  = 50
  }
  security_group_ids  = [module.module_oci_security.security_group_id]
  ssh_authorized_keys = var.ssh_authorized_keys
}
