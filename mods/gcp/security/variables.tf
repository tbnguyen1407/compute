variable "network_name" {
  type = string
}

variable "ingress_rules" {
  description = "Ingress rules in the format of map[name]def"
  type = map(object({
    protocol = string
    src      = string
    dst      = string
    port     = optional(string)
  }))
  default = {}
}

variable "egress_rules" {
  description = "Ingress rules in the format of map[name]def"
  type = map(object({
    protocol = string
    src      = string
    dst      = string
    port     = optional(string)
  }))
  default = {}
}
