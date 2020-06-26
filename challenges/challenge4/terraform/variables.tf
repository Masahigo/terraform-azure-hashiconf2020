variable "prefix" {
  description = "The prefix used for all resources in this example"
  default     = "masim-az-tf-challenge-2020-k8s"
}

variable "location" {
  description = "The Azure location where all resources in this example should be created"
  default     = "westeurope"
}

variable "subscription_id" {
  description = "Azure Subscription ID to be used for billing"
  default     = "16746c1e-ff8d-4f88-a96f-faa5e7903eda"
}

variable acr_name {
    default = "kserjds2323"
}

#variable "client_id" {}
#variable "client_secret" {}

variable "agent_count" {
    default = 1
}

variable "ssh_public_key" {
    default = "~/.ssh/id_rsa.pub"
}

variable "dns_prefix" {
    default = "k8s-masahigo-challenge4"
}

variable cluster_name {
    default = "k8s-masahigo-challenge4"
}

variable resource_group_name {
    default = "masim-az-tf-challenge-2020-k8s-rg"
}

variable log_analytics_workspace_name {
    default = "challenge4LogAnalyticsWorkspaceName"
}

# refer https://azure.microsoft.com/global-infrastructure/services/?products=monitor for log analytics available regions
variable log_analytics_workspace_location {
    default = "westeurope"
}

# refer https://azure.microsoft.com/pricing/details/monitor/ for log analytics pricing 
variable log_analytics_workspace_sku {
    default = "PerGB2018"
}