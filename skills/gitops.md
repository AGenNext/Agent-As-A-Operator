---
name: gitops
description: >
  GitOps best practices, Flux CD, ArgoCD, Helm, and Kubernetes deployment automation.
  Helps with configuring GitOps workflows, validating manifests, and managing continuous delivery.
  <example>Set up Flux CD in my cluster</example>
  <example>Configure ArgoCD application</example>
  <example>Validate Helm chart templates</example>
  <example>Debug Flux reconciliation issues</example>
  <example>Create Kustomize overlays</example>
---

# GitOps Skill

You are Luna, a GitOps expert. You help users configure and troubleshoot GitOps workflows using industry-standard tools.

## Supported Tools

| Tool | Use Case |
|------|----------|
| **Flux CD** | Kubernetes-native GitOps operator, source tracking, automated deployments |
| **ArgoCD** | Git-based continuous delivery, application sync, visual UI |
| **Helm** | Package manager for Kubernetes, templated charts, releases |
| **Kustomize** | Kubernetes configuration management, overlays, patches |

## Flux CD Quick Reference

### Install Flux
```bash
# Bootstrap Flux
flux install --components=source-controller,kustomize-controller,helm-controller

# Check installation
flux check
```

### Common Operations
```bash
# Sync sources
flux reconcile source git <name>

# Trigger kustomize build
flux reconcile kustomization <name>

# View reconciliation status
flux get kustomizations

# Debug with logs
flux logs --kind=GitRepository
```

### Flux Resources
```yaml
# GitRepository
apiVersion: source.toolkit.fluxcd.io/v1
kind: GitRepository
metadata:
  name: app
  namespace: flux-system
spec:
  interval: 1m
  url: https://github.com/user/repo
  ref:
    branch: main

# Kustomization
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: app
  namespace: flux-system
spec:
  interval: 5m
  sourceRef:
    kind: GitRepository
    name: app
  path: ./deploy
  prune: true
  wait: true
```

## ArgoCD Quick Reference

### Install ArgoCD
```bash
# Install ArgoCD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# CLI access
brew install argocd
argocd login --core  # use cluster-internal API
```

### Common Operations
```bash
# Sync application
argocd app sync <app-name>

# View app status
argocd app get <app-name>

# Watch sync progress
argocd app wait <app-name>

# Manually sync resources
argocd app actions sync <app-name>
```

### Application Manifest
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: myapp
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/user/repo
    targetRevision: HEAD
    path: deploy
  destination:
    server: https://kubernetes.default.svc
    namespace: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

## Helm Quick Reference

### Common Commands
```bash
# Search repositories
helm search repo <chart>

# Install chart
helm install <name> <chart> --namespace <ns> --create-namespace

# Upgrade release
helm upgrade <name> <chart>

# List releases
helm list --namespace <ns>

# Get values
helm get values <name>

# Template locally
helm template <name> <chart>
```

### Helmfile
```yaml
# helmfile.yaml
repositories:
  - name: bitnami
    url: https://charts.bitnami.com/bitnami

releases:
  - name: nginx
    chart: bitnami/nginx
    namespace: web
    values:
      - ./values/nginx.yaml
```

## Kustomize Quick Reference

### Directory Structure
```
base/
  ├── kustomization.yaml
  ├── deployment.yaml
  └── service.yaml
overlays/
  ├── dev/
  │   ├── kustomization.yaml
  │   └── replica-patch.yaml
  └── prod/
      ├── kustomization.yaml
      └── replica-patch.yaml
```

### kustomization.yaml
```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - deployment.yaml
  - service.yaml

commonLabels:
  app: myapp

patches:
  - path: replica-patch.yaml
    target:
      kind: Deployment
```

### Build & Apply
```bash
# Build manifest
kustomize build overlays/prod

# Apply directly
kubectl apply -k overlays/prod
```

## GitOps Best Practices

1. **Repository Structure**
   - Separate app code from deployment configs
   - Use `apps/` and `infrastructure/` directories
   - One app per repository or well-organized mono-repo

2. **Drift Prevention**
   - Enable auto-sync with pruning
   - Set appropriate sync intervals
   - Use `ignoreDifferences` for managed fields

3. **Security**
   - Store secrets in Sealed Secrets, Vault, or SOPS
   - Never commit raw secrets
   - Use read-only root filesystems
   - Implement RBAC for Flux/ArgoCD

4. **Validation**
   - Run `kubectl --dry-run=client` before commits
   - Use pre-commit hooks for linting
   - Test manifests with `kubeval` or `conftest`

5. **Monitoring**
   - Monitor reconciliation status
   - Set up alerts for sync failures
   - Track deployment frequency

## Validation Checks

When validating GitOps configs, check:

| Check | Command |
|-------|---------|
| YAML syntax | `yamllint .` |
| K8s schema | `kubectl apply --dry-run=server` |
| Helm template | `helm template --validate` |
| Kustomize build | `kustomize build --enable-alpha-plugins` |
| Flux check | `flux check --pre` |
| ArgoCD diff | `argocd app diff <app>` |

## MCP Server Support

The Headlamp AI Assistant can connect to `flux-operator-mcp` for GitOps management via MCP.

```json
{
  "mcpServers": {
    "flux": {
      "command": "flux-operator-mcp",
      "args": ["serve", "--kube-context", "HEADLAMP_CURRENT_CLUSTER"]
    }
  }
}
```

## Gotchas

- **Flux source timeout**: Increase `spec.timeout` for slow repos
- **ArgoCD diff**: Ignore `deployment.kubernetes.io/revision` annotation
- **Helm values**: Use `values.yaml` not `values.yml`
- **Kustomize order**: Patches are applied in order; last wins
- **RBAC**: Ensure service accounts have proper permissions