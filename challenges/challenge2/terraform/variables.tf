variable "prefix" {
  description = "The prefix used for all resources in this example"
  default     = "toa"
}

variable "location" {
  description = "The Azure location where all resources in this example should be created"
  default     = "westeurope"
}

variable "subscription_id" {
  description = "Azure Subscription ID to be used for billing"
}

variable "branch" {
  description = "The branch name of the repository"
  default     = "master"
}

variable "repo_url" {
  description = "Repository url to pull the latest source from"
  default     = "https://github.com/Terraform-On-Azure-Workshop/AzureEats-Website"
}

variable "mongodb_login_name" {
  default     = "user"
  description = "Login name for the MongoDb. If not set the default login name will be 'user'."
}

variable "admin_login_name" {
  default     = "sqladmin"
  description = "Login name for the sql server administrator. If not set the default login name will be 'sqladmin'."
}

variable "database_name" {
  default     = "azure-eats-db"
  description = "Name on the initial database on the server."
}

variable "sql_database_collation" {
  default     = "SQL_LATIN1_GENERAL_CP1_CI_AS"
  description = "Which collation the initial Azure SQL database should have."
}

variable "sql_database_edition" {
  default     = "Standard"
  description = "Which database scaling edition the Azure SQL database should have."
}

variable "sql_database_requested_service_objective_name" {
  default     = "S1"
  description = "Which service scaling objective the Azure SQL database should have."
}