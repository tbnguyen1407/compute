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

resource "aws_security_group" "this" {
  ## optional
  name   = var.security_group_name
  vpc_id = var.network_id
  tags = {
    Name = var.security_group_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress" {
  for_each = var.ingress_rules

  ## required
  security_group_id = aws_security_group.this.id
  ip_protocol       = local.m_protocols[each.value.protocol]

  ## optional
  cidr_ipv4 = each.value.src
  from_port = contains(["ICMP", "ICMPv6"], each.value.protocol) ? -1 : split("-", each.value.port)[0]
  to_port   = contains(["ICMP", "ICMPv6"], each.value.protocol) ? -1 : (length(split("-", each.value.port)) > 1 ? split("-", each.value.port)[1] : split("-", each.value.port)[0])
  tags = {
    Name = each.key
  }
}

resource "aws_vpc_security_group_egress_rule" "egress" {
  for_each = var.egress_rules

  ## required
  security_group_id = aws_security_group.this.id
  ip_protocol       = local.m_protocols[each.value.protocol]

  ## optional
  cidr_ipv4 = each.value.dst
  tags = {
    Name = each.key
  }
}
