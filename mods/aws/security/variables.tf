## required
variable "network_id" {
  type = string
}

## optional
variable "security_group_name" {
  type    = string
  default = "sg0"
}

variable "ingress_rules" {
  description = "Ingress rules in the format of map[name]def"
  type = map(object({
    protocol = string
    src      = string
    port     = optional(string)
  }))
  default = {}
}

variable "egress_rules" {
  description = "Ingress rules in the format of map[name]def"
  type = map(object({
    protocol = string
    dst      = string
    port     = optional(string)
  }))
  default = {}
}
