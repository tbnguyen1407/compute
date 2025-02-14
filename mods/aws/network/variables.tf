## optional
variable "network_name" {
  type    = string
  default = "net0"
}

variable "subnet_name" {
  type    = string
  default = "subnet0"
}

variable "network_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  type    = string
  default = "10.0.1.0/24"
}
