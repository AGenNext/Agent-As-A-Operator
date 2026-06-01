# ArgoCD E2E Tests

Automated end-to-end testing for Headlamp AI Assistant deployment via ArgoCD.

## Prerequisites

- ArgoCD installed and accessible
- `argocd` CLI installed
- Kubernetes cluster with ArgoCD

## Setup ArgoCD

```bash
# Install ArgoCD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Install CLI
brew install argocd  # macOS
# or: curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64

# Login
argocd login localhost:8080 --username admin --password <password>

# Update server context
argocd cluster add kubernetes --server localhost:8080
```

## Deploy Application

```bash
# Create the application
kubectl apply -f argocd-app.yaml

# Or via CLI
argocd app create headlamp-ai \
  --repo https://github.com/headlamp-k8s/plugins.git \
  --path ai-assistant/pod-manager/stackbuilder \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace headlamp \
  --sync-policy automated \
  --auto-prune \
  --self-heal
```

## Run Tests

```bash
# Set environment
export ARGOCD_SERVER=localhost:8080
export ARGOCD_APP=headlamp-ai

# Run tests
chmod +x run-argocd-tests.sh
./run-argocd-tests.sh
```

## Test Coverage

| Test | Description |
|------|-------------|
| App Exists | Verify application is registered |
| App Health | Check application health status |
| App Sync | Verify sync status is Synced |
| History | Check deployment history |
| Manual Sync | Trigger and verify sync |
| Resources | Validate all resources healthy |
| Manifests | Validate YAML syntax |

## Expected Output

```
==========================================
ArgoCD E2E Test Suite
==========================================

→ INFO Starting ArgoCD E2E tests...
→ INFO Server: localhost:8080
→ INFO App: headlamp-ai

=== ArgoCD Application Tests ===
✓ PASS: Application 'headlamp-ai' exists
✓ PASS: Application is Healthy
✓ PASS: Application is Synced
✓ PASS: Application has 3 revision(s)

=== Sync Tests ===
✓ PASS: Sync triggered successfully
✓ PASS: Sync completed successfully

=== Resource Tests ===
✓ PASS: All resources are healthy
✓ PASS: Resource exists: pod-manager (Deployment)
✓ PASS: Resource exists: flux-mcp-server (Deployment)
✓ PASS: Resource exists: prometheus-mcp-server (Deployment)

=== Manifest Validation ===
✓ PASS: stack.yaml is valid YAML
✓ PASS: argocd-app.yaml is valid

==========================================
ArgoCD E2E Test Summary
==========================================
  Passed: 11
  Failed: 0

All tests passed! ✓
```

## Cleanup

```bash
# Delete application
argocd app delete headlamp-ai --server localhost:8080 --yes

# Or via kubectl
kubectl delete -f argocd-app.yaml
```