terraform {
  backend "azurerm" {
    resource_group_name   = "masim-az-coding-challenge-2020-tf-state-rg"
    storage_account_name  = "azcodetfstatewestor"
    container_name        = "tfstate"
    key                   = "dev.terraform.tfstate"
  }
}

# Configure the AzureRM provider (using v2.1)
provider "azurerm" {
  version         = "~>2.14.0"
  subscription_id = var.subscription_id
  features {}
}

# Provision a resource group to hold all Azure resources
resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-resources"
  location = var.location
}

# Provision the App Service plan to host the App Service web app
resource "azurerm_app_service_plan" "main" {
  name                = "${var.prefix}-asp"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  kind                = "Windows"

  sku {
    tier = "Standard"
    size = "S1"
  }
}

# Provision the Azure App Service to host the main web site
resource "azurerm_app_service" "main" {
  name                = "${var.prefix}-appservice"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  app_service_plan_id = azurerm_app_service_plan.main.id

  site_config {
    always_on         = true
    scm_type          = "ExternalGit"
    default_documents = [
      "Default.htm",
      "Default.html",
      "hostingstart.html"
    ]
  }

  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "10.15.2"
    "ApiUrl"                       = ""
    "ApiUrlShoppingCart"           = ""
    "MongoConnectionString"        = "mongodb://user:${random_password.mongodbpassword.result}@${azurerm_container_group.main.fqdn}:27017"
    "SqlConnectionString"          = ""
    "productImagesUrl"             = "https://raw.githubusercontent.com/microsoft/TailwindTraders-Backend/master/Deploy/tailwindtraders-images/product-detail"
    "Personalizer__ApiKey"         = ""
    "Personalizer__Endpoint"       = ""
  }
}

resource "null_resource" "appserviceci" {
  triggers = {
    version = "0.0.1"
  }

  provisioner "local-exec" {
    command = "az webapp deployment source config --branch ${var.branch} --manual-integration --name ${azurerm_app_service.main.name} --repo-url ${var.repo_url} --resource-group ${azurerm_resource_group.main.name}"
  }

  depends_on = [
    azurerm_app_service.main
  ]
}

resource "random_password" "mongodbpassword" {
  length = 16
  special = true
  override_special = "_%@"
}

resource "azurerm_storage_account" "main" {
  name                     = substr(replace("${var.prefix}stor", "-", ""), 0, 24)
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "main" {
  name                 = "mongodata"
  storage_account_name = azurerm_storage_account.main.name
  quota                = 50
}

resource "azurerm_container_group" "main" {
  name                = "${var.prefix}-continst"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  ip_address_type     = "public"
  dns_name_label      = "${var.prefix}-continst"
  os_type             = "linux"

  container {
    name     = "mongo"
    image    = "mongo"
    cpu      = "1"
    memory   = "1.5"

    ports {
      port     = 27017
      protocol = "TCP"
    }

    volume {
      name       = "database"
      mount_path = "/data/mongoaz"
      read_only  = false
      share_name = azurerm_storage_share.main.name

      storage_account_name = azurerm_storage_account.main.name
      storage_account_key  = azurerm_storage_account.main.primary_access_key
    }

    environment_variables = {
        MONGO_INITDB_DATABASE = "azure-eats-db"
        MONGODB_USER          = "user"
        MONGODB_PASS          = random_password.mongodbpassword.result
    }

    commands = ["mongod", "--dbpath=/data/mongoaz", "--bind_ip_all", "--auth"]
  }

  tags = {
    environment = "dev"
  }

}