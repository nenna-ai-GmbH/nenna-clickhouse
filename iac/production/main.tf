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