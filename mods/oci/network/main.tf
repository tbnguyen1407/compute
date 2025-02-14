terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
    }
  }
}

resource "oci_identity_compartment" "cpt0" {
  ## required
  compartment_id = var.tenancy_id
  name           = var.compartment_name
  description    = var.compartment_name
}

## network
resource "oci_core_vcn" "net0" {
  ## required
  compartment_id = oci_identity_compartment.cpt0.id
  cidr_blocks    = var.network_cidr_blocks

  ## optional
  display_name = var.network_name
}

resource "oci_core_subnet" "subnet0" {
  ## required
  compartment_id = oci_identity_compartment.cpt0.id
  vcn_id         = oci_core_vcn.net0.id
  cidr_block     = var.subnet_cidr_block

  ## optional
  route_table_id             = oci_core_route_table.rt0.id
  display_name               = var.subnet_name
  prohibit_public_ip_on_vnic = false
}

## internet gateway
resource "oci_core_internet_gateway" "igw0" {
  ## required
  compartment_id = oci_identity_compartment.cpt0.id
  vcn_id         = oci_core_vcn.net0.id

  ## optional
  display_name = "igw0"
}

resource "oci_core_route_table" "rt0" {
  ## required
  compartment_id = oci_identity_compartment.cpt0.id
  vcn_id         = oci_core_vcn.net0.id

  ## optional
  display_name = "rt0"
  route_rules {
    network_entity_id = oci_core_internet_gateway.igw0.id
    destination       = "0.0.0.0/0"
  }
}
