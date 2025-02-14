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

resource "google_compute_firewall" "fw" {
  for_each = { for rule in var.rules : rule.name => rule }

  ## required
  name    = each.value.name
  network = var.network_name

  ## optional
  direction = each.value.direction
  allow {
    protocol = local.m_protocols[each.value.protocol]
    ports    = contains(["TCP", "UDP"], each.value.protocol) ? [each.value.dst_port] : null
  }
  source_ranges      = each.value.direction == "INGRESS" ? [each.value.src] : null
  destination_ranges = each.value.direction == "EGRESS" ? [each.value.dst] : null

  target_tags = [each.value.name]
}
