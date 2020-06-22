#!/bin/bash

set -e

RESOURCE_GROUP_NAME=$1
APP_SERVICE_NAME=$2
GITHUB_REPO="https://github.com/microsoft/TailwindTraders-Website"
GIT_BRANCH=master

#source "$(pwd)/bin/azlogin.sh"

az webapp deployment source config --branch $GIT_BRANCH --manual-integration --name $APP_SERVICE_NAME --repo-url $GITHUB_REPO --resource-group $RESOURCE_GROUP_NAME
