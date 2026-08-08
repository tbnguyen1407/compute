terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

locals {
  m_protocols = {
    ALL    = "all"
    ICMP   = "icmp"
    TCP    = "tcp"
    UDP    = "udp"
    ICMPv6 = "58"
  }
}

resource "google_compute_firewall" "ingress" {
  for_each = var.ingress_rules

  ## required
  name    = each.key
  network = var.network_name

  ## optional
  direction = "INGRESS"
  allow {
    protocol = local.m_protocols[each.value.protocol]
    ports    = contains(["TCP", "UDP"], each.value.protocol) ? [each.value.port] : null
  }
  destination_ranges = [each.value.dst]
  source_ranges      = [each.value.src]
}

resource "google_compute_firewall" "egress" {
  for_each = var.egress_rules

  ## required
  name    = each.key
  network = var.network_name

  ## optional
  direction = "INGRESS"
  allow {
    protocol = local.m_protocols[each.value.protocol]
    ports    = contains(["TCP", "UDP"], each.value.protocol) ? [each.value.port] : null
  }
  destination_ranges = [each.value.dst]
  source_ranges      = [each.value.src]
}
