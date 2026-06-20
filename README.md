# LearningSteps Evolution

Cloud-native DevSecOps deployment of the LearningSteps FastAPI application on Microsoft Azure.

The project evolves a manually operated two-tier application into an automated platform using Terraform, Docker, Azure Kubernetes Service, Azure Key Vault, PostgreSQL, and GitHub Actions.

## Architecture

```text
Developer
  -> GitHub repository
  -> GitHub Actions
       -> lint and tests
       -> secret and security scans
       -> Docker build
       -> Azure Container Registry
       -> Azure Kubernetes Service
            -> LoadBalancer Service
            -> FastAPI Deployment
            -> Horizontal Pod Autoscaler
            -> Azure Key Vault Secrets Provider
            -> private Azure PostgreSQL Flexible Server
```

## Main Components

- **FastAPI** provides the LearningSteps journal API.
- **Docker** packages the application as a reproducible container image.
- **Terraform** provisions the Azure infrastructure.
- **Azure Container Registry (ACR)** stores verified container images.
- **Azure Kubernetes Service (AKS)** runs and manages the application.
- **Azure PostgreSQL Flexible Server** stores journal entries on a private network.
- **Azure Key Vault** stores the database connection string.
- **GitHub Actions** automates linting, tests, scans, image publishing, and deployment.
- **TruffleHog and Trivy** enforce security checks in the pipeline.

## Repository Structure

```text
.
|-- .github/workflows/    # GitHub Actions DevSecOps pipeline
|-- app/                  # FastAPI source, tests, and database schema
|-- evidence/             # Deployment and validation evidence
|-- infra-terraform/      # Azure infrastructure as code
|-- k8s-manifests/        # Kubernetes resources
|-- Dockerfile            # Container build definition
`-- README.md
```

## Infrastructure

Terraform provisions:

- one Azure resource group,
- one virtual network,
- dedicated AKS and PostgreSQL subnets,
- Azure Container Registry,
- Azure Kubernetes Service,
- private PostgreSQL Flexible Server and application database,
- Azure Key Vault and the database connection secret,
- managed identities and scoped Azure role assignments.

PostgreSQL public network access is disabled. The application reaches the database through the Azure virtual network and private DNS.

## Kubernetes Deployment

The manifests in `k8s-manifests/` define:

- a dedicated `learningsteps` namespace,
- a ConfigMap for non-secret runtime configuration,
- a SecretProviderClass for Azure Key Vault integration,
- a FastAPI Deployment,
- a public LoadBalancer Service,
- CPU and memory requests and limits,
- a Horizontal Pod Autoscaler with one to three replicas.

The database connection is retrieved from Azure Key Vault and exposed to the application as the `DATABASE_URL` environment variable. The secret value is not stored in Git.

## CI/CD Pipeline

Every push to `main` triggers the following workflow:

1. Install Python dependencies.
2. Check critical Python errors with Ruff.
3. Run automated API tests with pytest.
4. Scan Git history for secrets with TruffleHog.
5. Scan Terraform for HIGH and CRITICAL misconfigurations with Trivy.
6. Build the Docker image.
7. Scan the image for HIGH and CRITICAL vulnerabilities.
8. Push the verified image to ACR.
9. Connect to AKS.
10. Apply the Kubernetes manifests.
11. Deploy the immutable image tagged with the Git commit SHA.
12. Wait for successful Kubernetes rollout.

Azure authentication uses OpenID Connect (OIDC). GitHub obtains short-lived Azure credentials instead of storing a permanent client secret.

## Verified Deployment

The successful pipeline run `27873181001` deployed:

```text
lstepsdev3nafhr.azurecr.io/learningsteps-api:c2763d15eb42c1d43d9c5959926161fb6ec64c19
```

The image tag matches the Git commit that triggered the deployment.

Runtime checks confirmed:

- the application Pod is `1/1 Running`,
- the Pod has no restarts,
- the Horizontal Pod Autoscaler receives CPU metrics,
- Swagger UI returns HTTP `200`,
- the API connects to private PostgreSQL,
- Create, Read, List, and Delete operations work,
- requesting a deleted entry returns HTTP `404`.

## Local Validation

Run the automated checks from the repository root:

```powershell
python -m pytest app\api\tests -q
python -m ruff check app\api --select E9,F63,F7,F82
terraform -chdir=infra-terraform fmt -check
terraform -chdir=infra-terraform validate
kubectl apply --dry-run=client -f k8s-manifests
```

## Deployment Checks

```powershell
kubectl get pods -n learningsteps
kubectl get hpa -n learningsteps
kubectl rollout status deployment/learningsteps-api -n learningsteps
```

The current public Swagger endpoint is:

```text
http://20.238.246.147/docs
```

The public IP can change if the LoadBalancer Service is recreated.

## Security Controls

- No database credentials are committed to the repository.
- PostgreSQL public network access is disabled.
- Azure Key Vault stores the database connection string.
- AKS uses managed identities.
- The ACR administrator account is disabled.
- GitHub uses OIDC instead of a permanent Azure client secret.
- Azure permissions are scoped to ACR and AKS.
- The pipeline blocks unapproved HIGH and CRITICAL security findings.
- Accepted MVP findings are documented in `evidence/accepted-security-risks.md`.

## Known Limitations

- The public API currently uses HTTP rather than HTTPS.
- Database schema initialization is currently a manual deployment step.
- Selected infrastructure findings are temporarily accepted for this learning MVP.
- The workflow uses administrative AKS credentials for deployment.
- Prometheus and Grafana observability were optional and are not implemented.

## Evidence

Detailed command outputs and validation records are available in the `evidence/` directory, including:

- local application smoke test,
- Docker container smoke test,
- Terraform resource deployment,
- ACR image push,
- AKS cluster deployment,
- AKS access and ACR pull authorization,
- accepted security risks.
