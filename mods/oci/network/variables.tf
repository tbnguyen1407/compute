## required
variable "tenancy_id" {
  type        = string
  description = "Root compartment ocid. New compartment will be child to root compartment"
}

## optional
variable "compartment_name" {
  type    = string
  default = "cpt0"
}

variable "network_name" {
  type    = string
  default = "net0"
}

variable "network_cidr_blocks" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "subnet_name" {
  type    = string
  default = "subnet0"
}

variable "subnet_cidr_block" {
  type    = string
  default = "10.0.1.0/24"
}
