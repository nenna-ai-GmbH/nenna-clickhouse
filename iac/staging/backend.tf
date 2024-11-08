terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "nenna"

    workspaces {
      name = "nenna-clickhouse-staging"
    }
  }
}
