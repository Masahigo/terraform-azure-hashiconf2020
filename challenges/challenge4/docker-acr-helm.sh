#!/bin/bash
RESOURCEGROUP="masim-az-tf-challenge-2020-k8s-rg"
ACRNAME="kserjds2323"
CLUSTERNAME="k8s-masahigo-challenge4"
SAMPLEREPO="https://github.com/Masahigo/AzureEats-Website"
FILEPATH=AzureEats-Website/Source/Tailwind.Traders.Web
IMAGENAME=tailwindtraders

git clone $SAMPLEREPO
# Configure ACR and login
az configure --defaults acr=$ACRNAME
az acr login
# Build, tag and push to ACR
docker build -t $IMAGENAME -f $FILEPATH/Dockerfile $FILEPATH

ACRLOGINSERVER=$ACRNAME.azurecr.io
docker tag $IMAGENAME $ACRLOGINSERVER/$IMAGENAME:v1
docker push $ACRLOGINSERVER/$IMAGENAME:v1

# Get k8s context
az aks get-credentials --resource-group $RESOURCEGROUP --name $CLUSTERNAME --overwrite-existing
# Add mystic service account to k8s cluster
kubectl create sa ttsa
# Do Helm magic
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo update

helm upgrade --install $IMAGENAME ./AzureEats-Website/Deploy/helm/web --set ingress.hosts={$CLUSTERNAME} -f ./AzureEats-Website/Deploy/helm/gvalues.yaml -f ./AzureEats-Website/Deploy/helm/values.b2c.yaml

# Remove the sample app local repo
rm -rf AzureEats-Website