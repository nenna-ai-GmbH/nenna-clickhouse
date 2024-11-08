# clickhouse Infrastructure Module

This Terraform module creates a highly available clickhouse infrastructure on Hetzner Cloud. It sets up multiple servers behind a load balancer, providing a secure and scalable environment for the clickhouse application.

## Infrastructure Components

1. **Servers (hcloud_server)**

   - Multiple servers are created based on the `server_count` variable
   - Configured with SSH access and HTTP
   - Utilizes cloud-init for initial configuration. This creates a user `kamal` for kamal deployments.

2. **Load Balancer (hcloud_load_balancer)**

   - Named "clickhouse-lb"
   - Uses the "lb11" load balancer type
   - Located in the same region as the servers
   - Implements a round-robin algorithm for traffic distribution

3. **Load Balancer Targets (hcloud_load_balancer_target)**

   - Connects each server to the load balancer

4. **Load Balancer Service (hcloud_load_balancer_service)**

   - Listens on port 443 (HTTPS)
   - Forwards traffic to port 80 on the servers
   - Uses an SSL certificate for HTTPS termination
   - Implements health checks on the "/latest/health" path

5. **Network Configuration**
   - Servers and load balancer are attached to a private network
   - Load balancer is assigned a static IP (10.0.0.20) within the private network

## Prerequisites

> [!TIP]
> All necessary variables and secrets can be found in 1Password

- Hetzner Cloud account and API token (different tokens for staging and production)
- Existing SSH key named "ssh-key-for-hetzner"
- Existing private network named "private-network"
- SSL certificate named "clickhouse-certificate" for HTTPS termination

## Usage

To use this module, include it in your Terraform configuration and provide the necessary variables in the `terraform.tfvars` file.

```hcl
hetzner_api_key = ""
hetzner_ssh_key     = ""
region              = "nbg1"
server_type         = "cx22"
operating_system    = "ubuntu-24.04"
server_count   = 1
```

## Applying the Infrastructure

To apply this Terraform configuration and create the infrastructure, follow these steps:

1. **Initialize Terraform**
   Run the following command to initialize Terraform and download the necessary providers:

   ```
   terraform init
   ```

2. **Review the Plan**
   Generate and review the execution plan to see what changes will be made:

   ```
   terraform plan
   ```

3. **Apply the Configuration**
   If the plan looks correct, apply the configuration to create the infrastructure:

   ```
   terraform apply
   ```

   You will be prompted to confirm the action. Type 'yes' to proceed.

4. **Verify the Infrastructure**
   After the apply command completes, verify that all resources have been created successfully by checking the Hetzner Cloud Console or using the Hetzner CLI.

5. **Destroy the Infrastructure (Optional)**
   If you need to tear down the infrastructure, you can use:
   ```
   terraform destroy
   ```
   Be cautious with this command as it will remove all resources created by this Terraform configuration.

> [!IMPORTANT]
> Always ensure you're working in the correct environment (staging or production) by using the appropriate `terraform.tfvars` file and Hetzner API token.
