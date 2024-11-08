# Deployment Guide

This guide explains the deployment steps for both production and staging environments using Kamal.

## Prerequisites

1. Ensure you have Kamal installed on your local machine.
2. Make sure you have the necessary access rights and SSH keys set up for the target servers.
3. Verify that the infrastructure is properly set up using the Terraform configurations in the `iac` directory.

## Setup for New Environments

If you're setting up a new environment:

1. Create a new configuration file for your environment (e.g., `config/deploy/new_environment.rb`).
2. Define the necessary settings in this file, including server addresses, environment variables, and any environment-specific configurations.
3. Update your `config/deploy.rb` file to include the new environment if necessary.
4. Run the Kamal setup command for the new environment:

   ```
   kamal setup -d new_environment
   ```

   This command will prepare the servers for deployment, installing necessary dependencies and setting up the initial configuration.

## Deployment Steps

### For Staging

1. Navigate to the project root directory.
2. Run the following command to deploy to the staging environment:

   ```
   kamal deploy -d staging
   ```

3. Kamal will use the configuration for the staging environment to deploy the application to the staging servers.
4. Monitor the deployment process in the console output.
5. Once completed, verify the deployment by accessing the staging URL.

### For Production

1. Navigate to the project root directory.
2. Run the following command to deploy to the production environment:

   ```
   kamal deploy -d production
   ```

3. Kamal will use the configuration for the production environment to deploy the application to the production servers.
4. Monitor the deployment process in the console output.
5. Once completed, verify the deployment by accessing the production URL.

## Rolling Back

If you need to roll back to a previous version:

1. For staging:
   ```
   kamal rollback -d staging
   ```

2. For production:
   ```
   kamal rollback -d production
   ```

## Checking Deployment Status

To check the status of your deployment:

1. For staging:
   ```
   kamal status -d staging
   ```

2. For production:
   ```
   kamal status -d production
   ```

## Important Notes

- Always test changes in the staging environment before deploying to production.
- Ensure that all necessary environment variables are properly set for each environment.
- Regularly update and maintain your Kamal configuration files to reflect any changes in your infrastructure or deployment process.

For more detailed information on Kamal commands and options, refer to the official Kamal documentation.



