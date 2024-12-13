# nenna-clickhouse

Just small repo to host the clickhouse config, since there was a desire
to not couple clickhouse directly with the backend stack

## Start clickhouse manually

```sh
sudo -u clickhouse /usr/bin/clickhouse-server --config-file /etc/clickhouse-server/config.xml

sudo mkdir -p /etc/clickhouse-server
sudo chown -R clickhouse:clickhouse /var/lib/clickhouse
sudo chown -R clickhouse:clickhouse /var/log/clickhouse-server
sudo chown -R clickhouse:clickhouse /etc/clickhouse-server

# First, ensure the config directory permissions are correct
sudo chown -R clickhouse:clickhouse /etc/clickhouse-server
sudo chmod -R 755 /etc/clickhouse-server

# Then, set up the storage directory permissions
sudo mkdir -p /mnt/HC_Volume_101756196/tmp
sudo chown -R clickhouse:clickhouse /mnt/HC_Volume_101756196
sudo chmod -R 755 /mnt/HC_Volume_101756196
```

sudo systemctl restart clickhouse-server
