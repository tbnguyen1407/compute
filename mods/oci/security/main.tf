terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
    }
  }
}

locals {
  m_protocols = {
    ALL    = "all"
    ICMP   = "1"
    TCP    = "6"
    UDP    = "17"
    ICMPv6 = "58"
  }
}

resource "oci_core_network_security_group" "this" {
  ## required
  compartment_id = var.compartment_id
  vcn_id         = var.network_id

  ## optional
  display_name = var.security_group_name
}

resource "oci_core_network_security_group_security_rule" "ingress" {
  for_each = var.ingress_rules

  ## required
  network_security_group_id = oci_core_network_security_group.this.id
  direction                 = "INGRESS"
  protocol                  = local.m_protocols[each.value.protocol]

  ## optional
  description = each.key
  source      = each.value.src
  source_type = "CIDR_BLOCK"

  dynamic "tcp_options" {
    for_each = each.value.protocol == "TCP" ? ["1"] : []

    content {
      dynamic "destination_port_range" {
        for_each = each.value.port != null ? ["1"] : []

        content {
          min = split("-", each.value.port)[0]
          max = length(split("-", each.value.port)) > 1 ? split("-", each.value.port)[1] : split("-", each.value.port)[0]
        }
      }
    }
  }

  dynamic "udp_options" {
    for_each = each.value.protocol == "UDP" ? ["1"] : []

    content {
      dynamic "destination_port_range" {
        for_each = each.value.port != null ? ["1"] : []

        content {
          min = split("-", each.value.port)[0]
          max = length(split("-", each.value.port)) > 1 ? split("-", each.value.port)[1] : split("-", each.value.port)[0]
        }
      }
    }
  }
}

resource "oci_core_network_security_group_security_rule" "egress" {
  for_each = var.egress_rules

  ## required
  network_security_group_id = oci_core_network_security_group.this.id
  direction                 = "EGRESS"
  protocol                  = local.m_protocols[each.value.protocol]

  ## optional
  description      = each.key
  destination      = each.value.dst
  destination_type = "CIDR_BLOCK"

  dynamic "tcp_options" {
    for_each = each.value.protocol == "TCP" ? ["1"] : []

    content {
      dynamic "source_port_range" {
        for_each = each.value.port != null ? ["1"] : []

        content {
          min = split("-", each.value.port)[0]
          max = length(split("-", each.value.port)) > 1 ? split("-", each.value.port)[1] : split("-", each.value.port)[0]
        }
      }
    }
  }

  dynamic "udp_options" {
    for_each = each.value.protocol == "UDP" ? ["1"] : []

    content {
      dynamic "source_port_range" {
        for_each = each.value.port != null ? ["1"] : []

        content {
          min = split("-", each.value.port)[0]
          max = length(split("-", each.value.port)) > 1 ? split("-", each.value.port)[1] : split("-", each.value.port)[0]
        }
      }
    }
  }
}
