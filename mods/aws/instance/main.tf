terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

## compute
resource "aws_instance" "ins" {
  count = var.instance_count

  ## required
  ami           = var.instance_bootdisk.image
  instance_type = var.instance_shape.type

  // optional
  tags = {
    Name = format("%s%d", var.instance_name_prefix, count.index)
  }

  credit_specification {
    cpu_credits = "standard"
  }

  root_block_device {
    volume_size = var.instance_bootdisk.size
    volume_type = var.instance_bootdisk.type
  }

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.nic0.id
  }

  key_name = aws_key_pair.keypair0.key_name
}

resource "aws_network_interface" "nic0" {
  ## required
  subnet_id = var.subnet_id

  ## optional
  security_groups = var.security_group_ids
  tags = {
    Name = format("%s-nic0", var.instance_name_prefix)
  }
}

## sshkeys
resource "aws_key_pair" "keypair0" {
  ## required
  key_name   = format("%s-keypair0", var.instance_name_prefix)
  public_key = join("\n", [for u, k in coalesce(var.ssh_authorized_keys, {}) : chomp(k)])

  ## optional
  tags = {
    Name = format("%s-keypair0", var.instance_name_prefix)
  }
}
