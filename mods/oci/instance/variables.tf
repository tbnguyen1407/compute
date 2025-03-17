## required
variable "compartment_id" {
  type = string
}

variable "network_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

## optional
variable "availability_domain" {
  type        = string
  default     = ""
  description = "AD to use. If not a random AD is selected"
}

variable "instance_count" {
  type    = number
  default = 1
}

variable "instance_shape" {
  type = object({
    type = string
    cpu  = optional(number)
    ram  = optional(number)
  })
  default = {
    type = "VM.Standard.E2.1.Micro"
    cpu  = 1
    ram  = 1
  }
}

variable "instance_bootdisk" {
  type = object({
    image = string
    size  = optional(number)
  })
  default = {
    image = "ocid1.image.oc1.ap-singapore-1.aaaaaaaaiyq36wrtjisfxsrbikhdgmvflpdc7yyjuqj4io6q4opunnytphxq"
    size  = 50
  }
}

variable "instance_state" {
  type    = string
  default = "RUNNING"
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
