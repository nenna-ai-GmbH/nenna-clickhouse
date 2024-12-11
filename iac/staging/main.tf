terraform {
  required_version = ">= 0.12"
}

module "clickhouse" {
  source          = "../modules/clickhouse"
  hetzner_api_key = var.hetzner_api_key
  clickhouse_password = var.clickhouse_password
  server_type = var.server_type
  server_count = var.server_count
  operating_system = var.operating_system
  region = var.region
  volume_mount_path = "/mnt/HC_Volume_101756196"
}

resource "hcloud_volume" "clickhouse_data" {
  name      = "clickhouse-data"
  size      = 10
  format    = "ext4"
  location  = var.region
}

resource "hcloud_volume_attachment" "main" {
  volume_id = hcloud_volume.clickhouse_data.id
  server_id = module.clickhouse.server_id
  automount = true
}

output "volume_mount_path" {
  value = "/mnt/HC_Volume_${hcloud_volume.clickhouse_data.id}"
}