help:
	@echo "# Makefile Help #"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


init: ## Create docker-compose shared network
	@echo "Create docker network"
	@docker network create shared_network 2>/dev/null || true


run: ## Run clickhouse
	docker compose up -d

tf-apply: ## Apply terraform
	cd staging && terraform apply -auto-approve
	ssh-keygen -R 157.90.24.158
