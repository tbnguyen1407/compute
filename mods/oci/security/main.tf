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

resource "oci_core_network_security_group" "nsg" {
  ## required
  compartment_id = var.compartment_id
  vcn_id         = var.network_id

  ## optional
  display_name = var.security_group_name
}

resource "oci_core_network_security_group_security_rule" "nsgrule" {
  for_each = { for rule in var.rules : rule.name => rule }

  ## required
  network_security_group_id = oci_core_network_security_group.nsg.id
  direction                 = each.value.direction
  protocol                  = local.m_protocols[each.value.protocol]

  ## optional
  description      = each.value.name
  source           = each.value.direction == "INGRESS" ? each.value.src : null
  source_type      = each.value.direction == "INGRESS" ? "CIDR_BLOCK" : null
  destination      = each.value.direction == "EGRESS" ? each.value.dst : null
  destination_type = each.value.direction == "EGRESS" ? "CIDR_BLOCK" : null

  dynamic "tcp_options" {
    for_each = each.value.protocol == "TCP" ? ["1"] : []

    content {
      dynamic "destination_port_range" {
        for_each = each.value.direction == "INGRESS" && each.value.dst_port != null ? ["1"] : []

        content {
          min = split("-", each.value.dst_port)[0]
          max = length(split("-", each.value.dst_port)) > 1 ? split("-", each.value.dst_port)[1] : split("-", each.value.dst_port)[0]
        }
      }

      dynamic "source_port_range" {
        for_each = each.value.direction == "EGRESS" && each.value.src_port != null ? ["1"] : []

        content {
          min = split("-", each.value.src_port)[0]
          max = length(split("-", each.value.src_port)) > 1 ? split("-", each.value.src_port)[1] : split("-", each.value.src_port)[0]
        }
      }
    }
  }

  dynamic "udp_options" {
    for_each = each.value.protocol == "UDP" ? ["1"] : []

    content {
      dynamic "destination_port_range" {
        for_each = each.value.direction == "INGRESS" && each.value.dst_port != null ? ["1"] : []

        content {
          min = split("-", each.value.dst_port)[0]
          max = length(split("-", each.value.dst_port)) > 1 ? split("-", each.value.dst_port)[1] : split("-", each.value.dst_port)[0]
        }
      }

      dynamic "source_port_range" {
        for_each = each.value.direction == "EGRESS" && each.value.src_port != null ? ["1"] : []

        content {
          min = split("-", each.value.src_port)[0]
          max = length(split("-", each.value.src_port)) > 1 ? split("-", each.value.src_port)[1] : split("-", each.value.src_port)[0]
        }
      }
    }
  }
}
