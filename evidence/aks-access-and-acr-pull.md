# AKS Access and ACR Pull Evidence

Date: 2026-06-18

## Purpose

This evidence documents successful local access to the Azure Kubernetes Service cluster and verifies that the AKS kubelet identity has the `AcrPull` role on Azure Container Registry.

## Terms

- AKS: Azure Kubernetes Service
- ACR: Azure Container Registry
- `kubectl`: Kubernetes command-line client
- `AcrPull`: Azure role that permits downloading container images from ACR

## AKS Credentials

```powershell
PS C:\Users\lukas\Desktop\Workspace\Github-Path\01-Uploaded-Repos\cs-projects\cs-3-learningsteps-evolution> kubectl version --client
Client Version: v1.36.0
Kustomize Version: v5.8.1
PS C:\Users\lukas\Desktop\Workspace\Github-Path\01-Uploaded-Repos\cs-projects\cs-3-learningsteps-evolution> az aks get-credentials --resource-group rg-learningsteps-evolution-dev --name aks-learningsteps-dev --overwrite-existing
Merged "aks-learningsteps-dev" as current context in C:\Users\lukas\.kube\config
```

## Operational Note

The first `kubectl` connection attempt failed because the AKS cluster was stopped. Azure reported:

```text
powerState: Stopped
provisioningState: Succeeded
```

After starting the cluster, Azure reported `Running` and the Kubernetes API became reachable.

## AKS Runtime Verification

```powershell
PS C:\Users\lukas\Desktop\Workspace\Github-Path\01-Uploaded-Repos\cs-projects\cs-3-learningsteps-evolution> az aks show --resource-group rg-learningsteps-evolution-dev --name aks-learningsteps-dev --query "{powerState:powerState.code,provisioningState:provisioningState,fqdn:fqdn}" --output table
PowerState    ProvisioningState    Fqdn
------------  -------------------  -------------------------------------------------------
Running       Succeeded            aks-learningsteps-dev-t7iyw4o3.hcp.westeurope.azmk8s.io
PS C:\Users\lukas\Desktop\Workspace\Github-Path\01-Uploaded-Repos\cs-projects\cs-3-learningsteps-evolution> kubectl get nodes
NAME                             STATUS   ROLES    AGE     VERSION
aks-system-15662235-vmss000001   Ready    <none>   2m58s   v1.34.8
PS C:\Users\lukas\Desktop\Workspace\Github-Path\01-Uploaded-Repos\cs-projects\cs-3-learningsteps-evolution> kubectl get namespaces
NAME              STATUS   AGE
default           Active   21h
kube-node-lease   Active   21h
kube-public       Active   21h
kube-system       Active   21h
```

## Terraform Role Assignment State

```text
azurerm_role_assignment.aks_acr_pull: Refreshing state
Plan: 0 to add, 5 to change, 0 to destroy.
```

The role assignment already exists in Terraform state. The remaining planned changes are unrelated tag and AKS default-setting drift; no resources are planned for destruction.

## Azure Role Verification

```powershell
PS C:\Users\lukas\Desktop\Workspace\Github-Path\01-Uploaded-Repos\cs-projects\cs-3-learningsteps-evolution> $acrId = az acr show --name lstepsdev3nafhr --query id --output tsv
PS C:\Users\lukas\Desktop\Workspace\Github-Path\01-Uploaded-Repos\cs-projects\cs-3-learningsteps-evolution> az role assignment list --assignee a559d9ea-d8b7-4b03-842a-359dca8ec3ad --scope $acrId --query "[].{Role:roleDefinitionName,PrincipalId:principalId}" --output table
Role     PrincipalId
-------  ------------------------------------
AcrPull  a559d9ea-d8b7-4b03-842a-359dca8ec3ad
```

## Result

The local `kubectl` client can access the running AKS cluster, the Kubernetes node is `Ready`, and the AKS kubelet identity has permission to pull images from the project ACR.
