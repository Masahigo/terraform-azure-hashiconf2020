# Solution

1) Create Service Principal for Terraform

```bash
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<your sub id>"
```

2) Save credentials to Github repo Secrets

- AZ_CLIENT_ID: `<appId>`
- AZ_CLIENT_SECRET: `<password>`
- AZ_TENANT_ID: `<tenant>`

3) Run the Github Action `.github/workflows/infra.yml`

or locally

```bash
terraform apply -var 'subscription_id=<your sub id>' -var 'prefix=<your prefix>'
```

4) Grab the site url from Terraform output

```bash
terraform output -json
```
