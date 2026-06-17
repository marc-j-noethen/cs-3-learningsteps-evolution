# ACR Image Push Evidence

Date: 2026-06-17

## Purpose

This evidence documents that the Dockerized LearningSteps API image was pushed successfully to Azure Container Registry.

## Image Details

- Local image: `learningsteps-api:local`
- ACR login server: `lstepsdev3nafhr.azurecr.io`
- ACR repository: `learningsteps-api`
- Image tag: `v1`
- Full image reference: `lstepsdev3nafhr.azurecr.io/learningsteps-api:v1`

## Original PowerShell Output

```powershell
PS C:\Users\lukas\Desktop\Workspace\Github-Path\01-Uploaded-Repos\cs-projects\cs-3-learningsteps-evolution> az acr login --name lstepsdev3nafhr
Login Succeeded
PS C:\Users\lukas\Desktop\Workspace\Github-Path\01-Uploaded-Repos\cs-projects\cs-3-learningsteps-evolution> docker tag learningsteps-api:local lstepsdev3nafhr.azurecr.io/learningsteps-api:v1
PS C:\Users\lukas\Desktop\Workspace\Github-Path\01-Uploaded-Repos\cs-projects\cs-3-learningsteps-evolution> docker push lstepsdev3nafhr.azurecr.io/learningsteps-api:v1
The push refers to repository [lstepsdev3nafhr.azurecr.io/learningsteps-api]
15dce8169a13: Pushed
9965a00bb5bc: Pushed
6dc8148c4b61: Pushed
6ec7f4e699d7: Pushed
3ebbd4cd9414: Pushed
4b6b2afbcb1e: Pushed
ef0c4f77ae79: Pushed
72c03230f136: Pushed
527b1d78e1a9: Pushed
v1: digest: sha256:de34fb6bdfe99ec9301e4b76567c4ec54de59aee1b28d0580285a52c8567049a size: 856
PS C:\Users\lukas\Desktop\Workspace\Github-Path\01-Uploaded-Repos\cs-projects\cs-3-learningsteps-evolution> az acr repository list --name lstepsdev3nafhr --output table
Result
-----------------
learningsteps-api
PS C:\Users\lukas\Desktop\Workspace\Github-Path\01-Uploaded-Repos\cs-projects\cs-3-learningsteps-evolution> az acr repository show-tags --name lstepsdev3nafhr --repository learningsteps-api --output table
Result
--------
v1
```

## Result

The Docker image `learningsteps-api:v1` was successfully pushed to Azure Container Registry and verified through Azure CLI repository and tag checks.
