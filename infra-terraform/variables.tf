variable "project_name" {
  description = "Short name of the project used for Azure resource naming."
  type        = string
  default     = "learningsteps"
}

variable "environment" {
  description = "Deployment environment name."
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region where resources will be deployed."
  type        = string
  default     = "westeurope"
}

variable "resource_group_name" {
  description = "Name of the Azure resource group."
  type        = string
  default     = "rg-learningsteps-evolution-dev"
}

variable "tags" {
  description = "Common tags applied to Azure resources."
  type        = map(string)
  default = {
    project     = "learningsteps-evolution"
    environment = "dev"
    managed_by  = "terraform"
  }
}