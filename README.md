# nenna-clickhouse

Just small repo to host the clickhouse config, since there was a desire
to not couple clickhouse directly with the backend stack

## Cloudinit

- [clickhouse_config.yml](iac/modules/clickhouse/cloudinit/clickhouse_config.yml)
- [clickhouse_install.yml](iac/modules/clickhouse/cloudinit/clickhouse_install.yml)
- [clickhouse_start.yml](iac/modules/clickhouse/cloudinit/clickhouse_start.yml)

### Handy commands

```bash
cloud-init clean --logs
cloud-init clean --logs --reboot
```

```bash
sudo cloud-init single --name cc_write_files --frequency always --file <filename>
```

- Don't use `sh` feature, use `bash` instead!

```bash
sudo cat /var/log/cloud-init-output.log
sudo cat /var/log/cloud-init.log
```

### Just delete the server

```sh
terraform state list
terraform destroy -target="module.clickhouse.hcloud_server.clickhouse[0]"
```
