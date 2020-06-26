provider "azurerm" {
  version         = "~>2.14.0"
  subscription_id = var.subscription_id
  features {}
}

provider "azuread" {
}
provider "random" {
}

# define the password
resource "random_string" "password" {
  length  = 32
  special = true
}

resource "azurerm_resource_group" "k8s" {
    name     = var.resource_group_name
    location = var.location
}

# define the app
resource "azuread_application" "tfapp" {
  name                       = "mytfapp"
}

# define the service principal
resource "azuread_service_principal" "tfapp" {
  application_id = azuread_application.tfapp.application_id
}

# define the service principal password
resource "azuread_service_principal_password" "tfapp" {
  service_principal_id = azuread_service_principal.tfapp.id
  end_date = "2020-12-31T09:00:00Z"
  value = random_string.password.result
}

resource "azurerm_container_registry" "acr" {
  name                     = var.acr_name
  resource_group_name      = azurerm_resource_group.k8s.name
  location                 = azurerm_resource_group.k8s.location
  sku                      = "Basic"
  admin_enabled            = false
}

# Try to give permissions, to let the AKR access the ACR
resource "azurerm_role_assignment" "acrpull_role" {
  scope                            = azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  principal_id                     = azuread_service_principal.tfapp.object_id
  #skip_service_principal_aad_check = true

  depends_on = [
    azurerm_container_registry.acr,
    azuread_application.tfapp
  ]
}

resource "random_id" "log_analytics_workspace_name_suffix" {
    byte_length = 8
}

resource "azurerm_log_analytics_workspace" "test" {
    # The WorkSpace name has to be unique across the whole of azure, not just the current subscription/tenant.
    name                = "${var.log_analytics_workspace_name}-${random_id.log_analytics_workspace_name_suffix.dec}"
    location            = var.log_analytics_workspace_location
    resource_group_name = azurerm_resource_group.k8s.name
    sku                 = var.log_analytics_workspace_sku
}

resource "azurerm_log_analytics_solution" "test" {
    solution_name         = "ContainerInsights"
    location              = azurerm_log_analytics_workspace.test.location
    resource_group_name   = azurerm_resource_group.k8s.name
    workspace_resource_id = azurerm_log_analytics_workspace.test.id
    workspace_name        = azurerm_log_analytics_workspace.test.name

    plan {
        publisher = "Microsoft"
        product   = "OMSGallery/ContainerInsights"
    }
}

resource "azurerm_kubernetes_cluster" "k8s" {
    name                = var.cluster_name
    location            = azurerm_resource_group.k8s.location
    resource_group_name = azurerm_resource_group.k8s.name
    dns_prefix          = var.dns_prefix

    linux_profile {
        admin_username = "ubuntu"

        ssh_key {
            key_data = file(var.ssh_public_key)
        }
    }

    default_node_pool {
        name            = "agentpool"
        node_count      = var.agent_count
        vm_size         = "Standard_DS2_v2"
    }

    # Use the service principal created above
    service_principal {
        #client_id     = var.client_id
        #client_secret = var.client_secret
        client_id     = azuread_service_principal.tfapp.application_id
        client_secret = azuread_service_principal_password.tfapp.value
    }

    addon_profile {
        oms_agent {
        enabled                    = true
        log_analytics_workspace_id = azurerm_log_analytics_workspace.test.id
        }
    }

    tags = {
        Environment = "Development"
    }
}
