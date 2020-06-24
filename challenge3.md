# Solution

![Infra CI](https://github.com/Masahigo/terraform-azure-hashiconf2020/workflows/Infra%20CI/badge.svg)
![CD](https://github.com/Masahigo/terraform-azure-hashiconf2020/workflows/CD/badge.svg)

## Enable TF remote state

```shell
#!/bin/bash

RESOURCE_GROUP_NAME=<your rg name for tf remote state>
STORAGE_ACCOUNT_NAME=<your storage account name>
CONTAINER_NAME=tfstate

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location westeurope

# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Get storage account key
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query [0].value -o tsv)

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY

echo "storage_account_name: $STORAGE_ACCOUNT_NAME"
echo "container_name: $CONTAINER_NAME"
echo "access_key: $ACCOUNT_KEY"
```

## Configure state back end

```bash
# https://docs.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage#configure-state-back-end
export ARM_ACCESS_KEY=$ACCOUNT_KEY
```

Configure to `main.tf`:

```tf
terraform {
  backend "azurerm" {
    resource_group_name   = "<your rg name for tf remote state>"
    storage_account_name  = "<your storage account name>"
    container_name        = "tfstate"
    key                   = "<environment_name>.terraform.tfstate"
  }
}
```

## Verify remote state works

```bash
cd challenges/challenge3/terraform/
terraform init
terraform plan -var 'subscription_id=<your sub id>' -var 'prefix=<your prefix>'
```

## Setup Service Principal

```bash
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<your sub id>"
```

Save credentials to Github repo Secrets:

- AZ_CLIENT_ID: `<appId>`
- AZ_CLIENT_SECRET: `<password>`
- AZ_TENANT_ID: `<tenant>`

## Trigger new deployment (CD pipeline) 

The pipeline is triggered from Git tags:

```bash
USER=$(git log -1 --pretty=format:'%an')
TAG=UPDATED-`date +%Y-%m-%d-%H%M`
git tag -a $TAG -m "$TAG by $USER"
git push origin $TAG
```
