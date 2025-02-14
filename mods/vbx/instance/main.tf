terraform {
  required_providers {
    vbx = {
      source  = "terra-farm/virtualbox"
    }
  }
}

resource "virtualbox_vm" "ins" {
  count  = 2
  name   = format("vm-%02d", count.index + 1)
  image  = "/dwn/img/ubuntu-24.04.1-live-server-amd64.iso"
  cpus   = 2
  memory = "2GB"

  network_adapter {
    type = "bridged"
  }
}
