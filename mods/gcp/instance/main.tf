terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

## compute
resource "google_compute_instance" "ins" {
  count = var.instance_count

  ## required
  name                      = format("%s%d", var.instance_name_prefix, count.index)
  machine_type              = var.instance_shape["type"]
  allow_stopping_for_update = true
  boot_disk {
    source = google_compute_disk.bootdisk[count.index].name
  }
  network_interface {
    subnetwork = var.subnet_name
    access_config {
      network_tier = var.network_tier
    }
  }
  metadata = {
    ssh-keys = join("\n", [for u, k in coalesce(var.ssh_authorized_keys, {}) : format("%s:%s", chomp(u), chomp(k))])
  }
  tags = var.instance_network_tags
}

resource "google_compute_disk" "bootdisk" {
  count = var.instance_count

  ## required
  name = format("%s%d-bootdisk", var.instance_name_prefix, count.index)

  ## optional
  image = var.instance_bootdisk.image
  type  = var.instance_bootdisk.type
  size  = var.instance_bootdisk.size
}
