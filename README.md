# Production-Style EKS GitOps Example

This repository demonstrates a production-style, fully automated deployment stack on AWS using Terraform, EKS, ArgoCD, and GitHub Actions. It includes a simple FastAPI task service, GitOps manifests, observability, centralized logging, and documentation for bootstrapping and operating the system.

## Repository layout
- `app/` – FastAPI sample application, Dockerfile, and tests.
- `infra/terraform/` – Terraform IaC for networking, EKS, RDS, Redis, S3, and IAM (GitHub OIDC).
- `k8s/` – Kubernetes base manifests and overlays for the app.
- `observability/` – Prometheus and Grafana Helm values.
- `logging/` – Fluent Bit DaemonSet for shipping pod logs to Cloud Watch Logs.
- `argocd/` – ArgoCD installation manifests and Application definitions (App of Apps).
- `docs/` – Architecture, setup, and runbook documentation.
- `.github/workflows/` – GitHub Actions CI/CD pipelines.

> All credentials and environment-specific values must be supplied through GitHub Secrets/Variables, Kubernetes Secrets/ConfigMaps, or Terraform input variables. No secrets are commited to the repo.

## Quick start
1. Read `docs/SETUP.md` for bootstrap steps.
2. Provision AWS infrastructure with Terraform (S3 remote state, VPC, EKS, RDS, Redis, S3 buckets, IAM OIDC for GitHub Actions).
3. ArgoCD is installed automatically by the `deploy-all` workflow; it points at this repo's `main` branch and seeds the app/logging/observability Applications.
4. Run the CI/CD workflows from GitHub Actions to build/push the app image and update manifests. ArgoCD syncs the changes to EKS.
5. Observe logs in CloudWatch and metrics in Grafana.

Refer to `docs/ARCHITECTURE.md` and `docs/RUNBOOK.md` for more details.

