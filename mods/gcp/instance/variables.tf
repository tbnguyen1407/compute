variable "subnet_name" {
  type = string
}

variable "network_tier" {
  type    = string
  default = "PREMIUM" ## STANDARD|PREMIUM
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
    type = "e2-micro" ## free tier: e2-micro
  }
}

variable "instance_bootdisk" {
  type = object({
    image = string
    type  = optional(string)
    size  = optional(number)
  })
  default = {
    image = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
    type  = "pd-standard" ## free tier: pd-standard
    size  = 30            ## free tier: 30
  }
}

variable "instance_name_prefix" {
  type    = string
  default = "ins"
}

variable "instance_network_tags" {
  type    = list(string)
  default = []
}

variable "ssh_authorized_keys" {
  type    = map(string) ## map[user]pubkey
  default = null
}
