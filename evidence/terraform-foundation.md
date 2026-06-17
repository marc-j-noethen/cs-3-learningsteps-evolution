# Terraform Foundation Evidence

Date: 2026-06-17

## Purpose

This evidence documents the successful Terraform deployment of the Azure foundation resources for the LearningSteps Evolution project.

## Created Resources

- Azure Container Registry
- Virtual Network
- AKS subnet
- PostgreSQL subnet
- Key Vault
- Random suffix for globally unique names

## Azure CLI Verification

### Azure Container Registry

```powershell
PS C:\Users\lukas\Desktop\Workspace\Github-Path\01-Uploaded-Repos\cs-projects\cs-3-learningsteps-evolution> az acr list --resource-group rg-learningsteps-evolution-dev --query "[].{name:name, loginServer:loginServer, sku:sku.name, adminUserEnabled:adminUserEnabled}" --output table
Name             LoginServer                 Sku    AdminUserEnabled
---------------  --------------------------  -----  ------------------
lstepsdev3nafhr  lstepsdev3nafhr.azurecr.io  Basic  False
```

### Virtual Network

```powershell
PS C:\Users\lukas\Desktop\Workspace\Github-Path\01-Uploaded-Repos\cs-projects\cs-3-learningsteps-evolution> az network vnet show --resource-group rg-learningsteps-evolution-dev --name vnet-learningsteps-dev --query "{name:name, addressSpace:addressSpace.addressPrefixes}" --output json
{
  "addressSpace": [
    "10.42.0.0/16"
  ],
  "name": "vnet-learningsteps-dev"
}
```

### Key Vault

```powershell
PS C:\Users\lukas\Desktop\Workspace\Github-Path\01-Uploaded-Repos\cs-projects\cs-3-learningsteps-evolution> az keyvault list --resource-group rg-learningsteps-evolution-dev --query "[].{name:name, vaultUri:properties.vaultUri}" --output table
Name                  VaultUri
--------------------  ---------------------------------------------
kv-lsteps-dev-3nafhr  https://kv-lsteps-dev-3nafhr.vault.azure.net/
```

## Terraform Outputs

```powershell
PS C:\Users\lukas\Desktop\Workspace\Github-Path\01-Uploaded-Repos\cs-projects\cs-3-learningsteps-evolution> terraform -chdir=infra-terraform output
acr_login_server = "lstepsdev3nafhr.azurecr.io"
acr_name = "lstepsdev3nafhr"
resource_group_location = "westeurope"
resource_group_name = "rg-learningsteps-evolution-dev"
```

## State Handling Check

```powershell
PS C:\Users\lukas\Desktop\Workspace\Github-Path\01-Uploaded-Repos\cs-projects\cs-3-learningsteps-evolution> git status --ignored -s
!! .venv/
!! Project-Info/
!! app/api/__pycache__/
!! app/api/models/__pycache__/
!! app/api/repositories/__pycache__/
!! app/api/routers/__pycache__/
!! app/api/services/__pycache__/
!! infra-terraform/.terraform/
!! infra-terraform/terraform.tfstate
!! infra-terraform/terraform.tfstate.backup
```

## Result

The Azure foundation resources were successfully created with Terraform. The Azure Container Registry uses `adminUserEnabled = false`, and Terraform state files are ignored by Git.
