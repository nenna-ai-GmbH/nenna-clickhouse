terraform {
  required_version = ">= 0.12"
}

data "hcloud_network" "private_network" {
  name = "private-network"
}

resource "hcloud_server" "clickhouse" {
  count       = var.server_count
  name        = var.server_count > 1 ? "clickhouse-${count.index + 1}" : "clickhouse"
  image       = var.operating_system
  server_type = var.server_type
  location    = var.region
  keep_disk   = true
  labels = {
    "ssh"  = "yes",
    "http" = "yes"
  }

  user_data = data.cloudinit_config.cloud_config_clickhouse.rendered
  
  network {
    network_id = data.hcloud_network.private_network.id
  }

  depends_on = [data.hcloud_network.private_network]

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
}

data "cloudinit_config" "cloud_config_clickhouse" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content      = file("${path.module}/cloudinit/base.yml")
  }
}