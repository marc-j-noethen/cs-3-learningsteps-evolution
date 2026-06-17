# AKS Cluster Evidence

Date: 2026-06-17

## Purpose

This evidence documents the successful Terraform deployment and Azure CLI verification of the AKS cluster for the LearningSteps Evolution project.

## Created Resource

- AKS cluster: `aks-learningsteps-dev`
- Region: `westeurope`
- Node resource group: `MC_rg-learningsteps-evolution-dev_aks-learningsteps-dev_westeurope`
- Node pool VM size: `Standard_D2s_v3`

## Debugging Note

The first AKS apply attempts failed because the originally selected VM sizes were not usable in the subscription and region:

- `Standard_B2s` was not allowed in the subscription for `westeurope`.
- `Standard_B2s_v2` was allowed, but the subscription had no remaining quota for the `standardBsv2Family`.
- The node pool was changed to `Standard_D2s_v3`, which allowed AKS creation to succeed.

## Terraform Apply Output

```powershell
Apply complete! Resources: 1 added, 4 changed, 0 destroyed.

Outputs:

acr_login_server = "lstepsdev3nafhr.azurecr.io"
acr_name = "lstepsdev3nafhr"
aks_cluster_name = "aks-learningsteps-dev"
aks_node_resource_group = "MC_rg-learningsteps-evolution-dev_aks-learningsteps-dev_westeurope"
resource_group_location = "westeurope"
resource_group_name = "rg-learningsteps-evolution-dev"
PS C:\Users\lukas\Desktop\Workspace\Github-Path\01-Uploaded-Repos\cs-projects\cs-3-learningsteps-evolution>
```

## Azure CLI Verification

```powershell
PS C:\Users\lukas\Desktop\Workspace\Github-Path\01-Uploaded-Repos\cs-projects\cs-3-learningsteps-evolution> az aks show --resource-group rg-learningsteps-evolution-dev --name aks-learningsteps-dev --query "{name:name, powerState:powerState.code, kubernetesVersion:kubernetesVersion, nodeResourceGroup:nodeResourceGroup}" --output table
Name                   PowerState    KubernetesVersion    NodeResourceGroup
---------------------  ------------  -------------------  ------------------------------------------------------------------
aks-learningsteps-dev  Running       1.34                 MC_rg-learningsteps-evolution-dev_aks-learningsteps-dev_westeurope
```

## Git Status Check

```powershell
PS C:\Users\lukas\Desktop\Workspace\Github-Path\01-Uploaded-Repos\cs-projects\cs-3-learningsteps-evolution> git status
On branch main
Your branch is up to date with 'origin/main'.

nothing to commit, working tree clean
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

The AKS cluster was successfully created with Terraform and independently verified through Azure CLI. Terraform state files remain ignored by Git.
