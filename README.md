# nenna-clickhouse

Just small repo to host the clickhouse config, since there was a desire
to not couple clickhouse directly with the backend stack

## Available Make Commands

The following make commands are available to help you manage the Clickhouse instance and generate test data:

```bash
make help              # Show all available commands with descriptions
make run              # Start Clickhouse using Docker Compose
make start            # Alias for 'run'
make init             # Initialize the environment (create network and tables)
make create-network   # Create Docker Compose shared network
make create-tables    # Create Clickhouse tables
make test-data        # Generate test data
```

## Test Data Generation

The project includes a test data generator that can populate your Clickhouse instance with realistic sample data. The generator creates events with the following characteristics:

- Random timestamps weighted towards working hours
- Various user input types (text, PDF, images, etc.)
- Realistic detection patterns based on actual usage
- Multiple languages with weighted distribution (primarily EN and DE)
- Various event triggers (masking, de-masking, send)

To generate test data:

1. Ensure Clickhouse is running (the script will prompt you to start it if it's not)
2. Run:
   ```bash
   make test-data
   ```

The generator will create 25,000 sample events with realistic distributions of:

- Detection types (PERSON, ORGANISATION, LOCATION, etc.)
- Input types (text/plain, PDF, Word documents, etc.)
- Language codes (weighted towards EN and DE)
- Event triggers (weighted towards masking events)

### Requirements

- Python 3.x
- Pipenv (for dependency management)
- Docker and Docker Compose (for running Clickhouse)

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
