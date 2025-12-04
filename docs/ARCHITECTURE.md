# Architecture

## Overview
- **Network**: VPC with public subnets (ALB/ingress) and private subnets (EKS nodes, RDS, Redis). NAT gateway provides outbound access.
- **Compute**: EKS with managed node group. Application pods run in `task-app` namespace. HPA scales pods based on CPU utilization.
- **Data**: RDS PostgreSQL (multi-AZ, automated backups). ElastiCache Redis for caching GET responses. S3 buckets for file storage and backups.
- **GitOps**: ArgoCD in `argocd` namespace watches this repository's main branch and syncs Applications for app, logging, and observability.
- **CI/CD**: GitHub Actions build/test Docker image, push to ECR, update Kubernetes manifests (image tag), and commit changes. ArgoCD pulls updates.
- **Logging**: Fluent Bit DaemonSet ships container logs to CloudWatch Logs with namespace/pod labels.
- **Monitoring**: kube-prometheus-stack provides Prometheus, Alertmanager, and Grafana. Dashboards track latency, error rate, and resource usage.
- **Security**: IAM roles with least privilege, OIDC for GitHub Actions (no long-lived keys), Kubernetes Secrets for credentials, ConfigMaps for config, IRSA for pod-level permissions, encrypted storage (RDS/S3/Redis), and network isolation via security groups.

## Backup strategy
- RDS automated backups retained for 7 days (configurable in Terraform).
- S3 backup bucket for logical dumps or cron jobs (could be triggered via Kubernetes CronJob with IRSA).

## Performance considerations
- Horizontal scaling with HPA and cluster autoscaler (enabled via node group settings).
- Redis caching for read-heavy endpoints; cache invalidation on writes.
- Terraform variables expose instance sizes to adjust capacity.

## Secret management
- CI: GitHub Secrets/Variables (AWS_ACCOUNT_ID, AWS_REGION, ECR_REPOSITORY, DB_USERNAME, DB_PASSWORD, AWS_ROLE_TO_ASSUME).
- Runtime: Kubernetes Secrets (DB URL, Redis URL, Grafana admin password) mounted via env vars. ConfigMaps hold non-sensitive configs.

## GitOps flow
1. Developer merges PR to main.
2. GitHub Actions `cd-app` workflow builds/pushes image, updates manifest tag, and commits.
3. ArgoCD notices repo change and syncs workloads to EKS.
4. Rollbacks are handled by reverting the manifest commit; ArgoCD enforces desired state.
