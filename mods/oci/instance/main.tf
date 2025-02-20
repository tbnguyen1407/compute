terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
    }
  }
}

resource "oci_core_instance" "ins" {
  count = var.instance_count

  ## required
  compartment_id      = var.compartment_id
  availability_domain = coalesce(var.availability_domain, data.oci_identity_availability_domains.ads.availability_domains[0].name)
  shape               = var.instance_shape["type"]

  ## optional
  display_name = format("%s%d", var.instance_name_prefix, count.index)
  state        = var.instance_state
  source_details {
    ## required
    source_id   = var.instance_bootdisk["image"]
    source_type = "image"

    ## optional
    boot_volume_size_in_gbs = var.instance_bootdisk.size
  }
  shape_config {
    ## optional
    ocpus         = var.instance_shape.cpu
    memory_in_gbs = var.instance_shape.ram
  }
  create_vnic_details {
    ## required
    subnet_id = var.subnet_id

    ## optional
    display_name     = format("%s-vnic0", var.instance_name_prefix)
    assign_public_ip = true
    nsg_ids          = var.security_group_ids
  }
  metadata = {
    ssh_authorized_keys = join("\n", [for u, k in coalesce(var.ssh_authorized_keys, {}) : chomp(k)])
  }
}

data "oci_identity_availability_domains" "ads" {
  ## required
  compartment_id = var.compartment_id
}
