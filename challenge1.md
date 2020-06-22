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
az login --service-principal -u <appId> -p <password> --tenant <tenant>
az account set -s <your sub id>
cd challenges/challenge1/terraform
terraform apply -var 'subscription_id=<your sub id>' -var 'prefix=<your prefix>'
chmod +x ./bin/appservice-ci.sh
./bin/appservice-ci.sh <your prefix>-resources <your prefix>-appservice
```

4) Grab the site url from Terraform output

```bash
terraform output -json
```
