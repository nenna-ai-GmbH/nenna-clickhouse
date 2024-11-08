output "ipv4_web_address" {
  value = { for s in hcloud_server.clickhouse : s.name => s.ipv4_address }
}
