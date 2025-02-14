## required
variable "network_id" {
  type = string
}

## optional
variable "security_group_name" {
  type    = string
  default = "sg0"
}

variable "rules" {
  type = list(object({
    name      = string
    direction = optional(string, "INGRESS")
    protocol  = optional(string, "ALL")
    src       = optional(string, "0.0.0.0/0")
    src_port  = optional(string)
    dst       = optional(string, "0.0.0.0/0")
    dst_port  = optional(string)
  }))
  default = []

  ## validation
  validation {
    condition     = length(var.rules) == length(distinct(var.rules[*].name))
    error_message = "rule.name must be distinct"
  }
  validation {
    condition = alltrue([
      for rule in var.rules : contains(["INGRESS", "EGRESS"], rule.direction)
    ])
    error_message = "invalid rule.direction (INGRESS|EGRESS)"
  }
  validation {
    condition = alltrue([
      for rule in var.rules : contains(["ALL", "ICMP", "ICMPv6", "TCP", "UDP"], rule.protocol)
    ])
    error_message = "invalid rule.protocol (ALL|ICMP|ICMPv6|TCP|UDP)"
  }
  validation {
    condition = alltrue([
      for rule in var.rules : can(cidrhost(rule.src, 32))
    ])
    error_message = "invalid rule.src (CIDR)"
  }
  validation {
    condition = alltrue([
      for rule in var.rules : rule.dst_port == null || rule.dst_port != ""
    ])
    error_message = "invalid rule.dst_port (<port>|<port>-<port>)"
  }
}
