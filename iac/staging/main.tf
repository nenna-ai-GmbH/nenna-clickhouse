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
}

resource "hcloud_volume" "metabase_data" {
  name      = "metabase-data"
  size      = 10
  format    = "ext4"
  location  = var.region
}

resource "hcloud_volume_attachment" "main" {
  volume_id = hcloud_volume.metabase_data.id
  server_id = module.clickhouse.server_id
  automount = true
}