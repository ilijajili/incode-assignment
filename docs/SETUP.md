# Setup Guide

## Prerequisites
- AWS account and CLI configured
- Terraform >= 1.5, kubectl, Helm, kustomize
- GitHub repository with Actions enabled and OIDC trust configured
- S3 bucket + DynamoDB table for Terraform state/locking

## Configure GitHub Secrets/Variables
Set the following in GitHub Secrets/Variables:
- `AWS_ACCOUNT_ID`
- `AWS_REGION`
- `AWS_ROLE_TO_ASSUME` (OIDC role created by Terraform IAM module)
- `ECR_REPOSITORY`
- `DB_USERNAME`
- `DB_PASSWORD`
- `DB_NAME`
- `REDIS_AUTH_TOKEN`

The deploy workflows will automatically publish the connection strings to AWS Parameter Store (keys `task-app/database_url` and `task-app/redis_url`) after Terraform apply using the RDS/Redis endpoints and the GitHub-provided credentials above.

## Bootstrap Infrastructure
Run deploy-all.yml workflow.

## Deploy the App via GitOps
- Ensure Kubernetes Secrets are created matching `k8s/base/secret-placeholders.yaml` keys.
- ArgoCD will sync the app, observability, and logging stacks automatically from `main`.

## CI/CD Workflows
- **deploy-all.yml**: deploys all infra. 
- **ci-app.yaml**: run tests and build app image on PR or manual dispatch.
- **cd-app.yaml**: manual dispatch to build/push image, update manifest tag, and push commit. ArgoCD syncs the change.
- **performance-test.yaml**: optional k6 load test to detect regressions(beta).

## Accessing Observability
- Logs: CloudWatch Logs group `/eks/task-app/pods` created by Fluent Bit.
- Metrics: Grafana LoadBalancer URL; login using Grafana admin password stored in Kubernetes Secret.
- Alerts: Prometheus Alertmanager.
