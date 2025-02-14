variable "network_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "instance_count" {
  type    = number
  default = 1
}

variable "instance_shape" {
  type = object({
    type = string
  })
  default = {
    type = "t4g.small" ## free tier: t4g.small (until 31/12/2025)
  }
}

variable "instance_bootdisk" {
  type = object({
    image = string
    type  = optional(string)
    size  = optional(number)
  })
  default = {
    image = "ami-023d6c5b3a28a2d1d"
    type  = "gp3"
    size  = 30 ## free trial: 30
  }
}

variable "instance_name_prefix" {
  type    = string
  default = "ins"
}

variable "security_group_ids" {
  type    = list(string)
  default = []
}

variable "ssh_authorized_keys" {
  type    = map(string) ## map[user]pubkey
  default = null
}
