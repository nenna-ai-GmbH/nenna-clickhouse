help:
	@echo "# Makefile Help #"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


init: create-network create-tables ## Initialize the environment

create-network: ## Create docker-compose shared network
	@echo "Create docker network"
	@docker network create shared_network 2>/dev/null || true

create-tables: ## Create ClickHouse tables
	@echo "Creating ClickHouse tables..."
	@docker compose up -d
	@sleep 5  # Wait for ClickHouse to be ready
	@docker compose exec -T clickhouse clickhouse-client --multiquery < tables/event_mastking.sql
	@docker compose exec -T clickhouse clickhouse-client --multiquery < users/nenna_cloud.sql

run: ## Run clickhouse
	docker compose up -d

tf-apply: ## Apply terraform
	cd staging && terraform apply -auto-approve
	ssh-keygen -R 157.90.24.158
