# Terraform Resource Group Evidence

Date: 2026-06-14

## Purpose

This evidence documents the first successful Terraform deployment for the LearningSteps Evolution project.

## Terraform Scope

Terraform created the Azure resource group that will contain the DevSecOps infrastructure.

## Applied Resource

- Resource group: `rg-learningsteps-evolution-dev`
- Location: `westeurope`
- Managed by: Terraform

## Original PowerShell Output

```powershell
PS C:\Users\lukas\Desktop\Workspace\Github-Path\01-Uploaded-Repos\cs-projects\cs-3-learningsteps-evolution> terraform -chdir=infra-terraform apply

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

resource_group_location = "westeurope"
resource_group_name = "rg-learningsteps-evolution-dev"
PS C:\Users\lukas\Desktop\Workspace\Github-Path\01-Uploaded-Repos\cs-projects\cs-3-learningsteps-evolution> az group show --name rg-learningsteps-evolution-dev --query "{name:name, location:location, tags:tags}" --output table
Name                            Location
------------------------------  ----------
rg-learningsteps-evolution-dev  westeurope
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
```

## Terraform Apply Result

```text
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

## Azure CLI Verification

```text
Name                            Location
------------------------------  ----------
rg-learningsteps-evolution-dev  westeurope
```

## State Handling Check

```text
!! infra-terraform/terraform.tfstate
```

## Result

The Azure resource group was successfully created with Terraform and verified independently through Azure CLI. The Terraform state file is ignored by Git.
