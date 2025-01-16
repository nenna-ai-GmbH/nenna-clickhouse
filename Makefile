SHELL := $(SHELL)

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

start: run ## Alias to run

tf-apply: ## Apply terraform
	cd staging && terraform apply -auto-approve
	ssh-keygen -R 157.90.24.158

check-clickhouse: ## Check if Clickhouse is running
	@if ! docker ps | grep -q clickhouse; then \
		read -p "Clickhouse is not running. Would you like to start it? [y/N] " answer; \
		if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
			docker compose up -d; \
			echo "Waiting for Clickhouse to be ready..."; \
			for i in $$(seq 1 30); do \
				if docker compose exec -T clickhouse clickhouse-client --query "SELECT 1" >/dev/null 2>&1; then \
					echo "Clickhouse is ready!"; \
					break; \
				fi; \
				if [ $$i -eq 30 ]; then \
					echo "Timeout waiting for Clickhouse to be ready"; \
					exit 1; \
				fi; \
				echo "Waiting... ($$i/30)"; \
				sleep 1; \
			done; \
		else \
			echo "Clickhouse is required to run test data generation."; \
			exit 1; \
		fi \
	fi

setup-test-env: ## Setup Python environment for test data generation
	@cd testDataGernerator && pipenv install

test-data: check-clickhouse setup-test-env ## Generate test data
	@cd testDataGernerator && pipenv run python main.py
