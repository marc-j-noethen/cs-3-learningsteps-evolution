# Accepted Security Risks

Date: 2026-06-20

The CI pipeline blocks all unapproved HIGH and CRITICAL findings.

The following findings are temporarily accepted for the learning MVP:

- `AZU-0013`: Key Vault public network access is required by the current setup. Authentication and access policies remain enforced.
- `AZU-0041`: AKS API authorized IP ranges are not configured because GitHub-hosted runner addresses are dynamic.
- `AZU-0042`: Kubernetes RBAC is enabled by AKS defaults but is not explicit in the Terraform configuration.
- `AZU-0043`: A Kubernetes network policy provider is not configured in the current cluster.

These exceptions are narrowly scoped in `.trivyignore`. New HIGH or CRITICAL findings still fail the pipeline.

Production remediation:

- use private access for Key Vault,
- use private AKS or controlled runner addresses,
- declare RBAC explicitly,
- configure and enforce network policies.