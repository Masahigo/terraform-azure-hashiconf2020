# Solution

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- Helm3

```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
$ chmod 700 get_helm.sh
$ ./get_helm.sh
```

## 1. Provision AKS cluster and ACR with Terraform

```bash
cd challenges/challenge4/terraform
terraform init
terraform apply -auto-approve

$ az aks list -g masim-az-tf-challenge-2020-k8s-rg --query [0].fqdn -o tsv
k8s-masahigo-challenge4-d296fc1c.hcp.westeurope.azmk8s.io
```

## 2. Docker build and push to ACR + deploy sample app on AKS cluster using Helm

```bash
cd ..
chmod +x docker-acr-helm.sh 
./docker-acr-helm.sh 
```

## 3. Verify the sample is running properly in k8s

```bash
$ kubectl get pods
NAME                                     READY   STATUS    RESTARTS   AGE
tailwindtraders-tt-web-95dff454d-fpd9g   1/1     Running   0          8m46s

$ kubectl logs tailwindtraders-tt-web-95dff454d-fpd9g
info: Microsoft.AspNetCore.DataProtection.KeyManagement.XmlKeyManager[0]
      User profile is available. Using '/root/.aspnet/DataProtection-Keys' as key repository; keys will not be encrypted at rest.
info: Microsoft.AspNetCore.DataProtection.KeyManagement.XmlKeyManager[58]
      Creating key {25185f96-aa74-4238-94c9-a88ef202b681} with creation date 2020-06-26 06:13:40Z, activation date 2020-06-26 06:13:40Z, and expiration date 2020-09-24 06:13:40Z.
warn: Microsoft.AspNetCore.DataProtection.KeyManagement.XmlKeyManager[35]
      No XML encryptor configured. Key {25185f96-aa74-4238-94c9-a88ef202b681} may be persisted to storage in unencrypted form.
info: Microsoft.AspNetCore.DataProtection.Repositories.FileSystemXmlRepository[39]
      Writing data to file '/root/.aspnet/DataProtection-Keys/key-25185f96-aa74-4238-94c9-a88ef202b681.xml'.
Hosting environment: Production
Content root path: /web
Now listening on: http://[::]:80
Application started. Press Ctrl+C to shut down.
```
