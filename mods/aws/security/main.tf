terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

locals {
  m_protocols = {
    ALL    = "-1"
    ICMP   = "icmp"
    TCP    = "tcp"
    UDP    = "udp"
    ICMPv6 = "icmpv6"
  }
}

resource "aws_security_group" "sg0" {
  ## optional
  name   = var.security_group_name
  vpc_id = var.network_id
  tags = {
    Name = var.security_group_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress_rule" {
  for_each = { for rule in var.rules : rule.name => rule if rule.direction == "INGRESS" }

  ## required
  security_group_id = aws_security_group.sg0.id
  ip_protocol       = local.m_protocols[each.value.protocol]
  cidr_ipv4         = each.value.src
  from_port         = contains(["ICMP", "ICMPv6"], each.value.protocol) ? -1 : split("-", each.value.dst_port)[0]
  to_port           = contains(["ICMP", "ICMPv6"], each.value.protocol) ? -1 : (length(split("-", each.value.dst_port)) > 1 ? split("-", each.value.dst_port)[1] : split("-", each.value.dst_port)[0])

  ## optional
  tags = {
    Name = each.value.name
  }
}

resource "aws_vpc_security_group_egress_rule" "egress_rule" {
  for_each = { for rule in var.rules : rule.name => rule if rule.direction == "EGRESS" }

  ## required
  security_group_id = aws_security_group.sg0.id
  ip_protocol       = local.m_protocols[each.value.protocol]

  ## optional
  cidr_ipv4 = each.value.dst
}
