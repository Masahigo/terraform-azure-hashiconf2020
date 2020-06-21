# Solution

## IaC

1) Create Service Principal for Terraform

```bash
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<your sub id>"
```

2) Save credentials to Github repo Secrets

AZ_CLIENT_ID
AZ_CLIENT_SECRET
AZ_TENANT_ID

3) Create Github action for deploying infra

## CD

