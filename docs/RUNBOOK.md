# Runbook

## Common checks
- **App health**: `kubectl get pods -n task-app`; `kubectl describe deployment/task-app`.
- **Logs**: View in CloudWatch Logs group `/eks/task-app/pods` or stream locally with `kubectl logs`.
- **Metrics**: Access Grafana (LoadBalancer) and view dashboards `app-metrics` / `k8s-overview`.
- **ArgoCD sync**: `argocd app list` then `argocd app sync task-app` if manual sync is required.

## Backups & restore
- **RDS automated backups**: Managed by AWS; restore via RDS console to a new instance. Update Secrets with new endpoint.

## GitHub Secrets and Variables
Declare the following in the repository settings to keep automation working (values are placeholders and should match your environment):

**Repository variables (Actions > Variables):**
- `AWS_ACCOUNT_ID`
- `AWS_REGION`
- `AWS_ECR_REGISTRY`
- `ECR_REPOSITORY`
- `DB_NAME`
- `DB_USERNAME`

**Repository secrets (Actions > Secrets):**
- `DB_PASSWORD`
- `AWS_ROLE_TO_ASSUME`

> CI/CD reference these names directly; ensure they exist before triggering runs.
