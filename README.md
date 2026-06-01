# Luna - CNCF Native Agent

Kubernetes agent with Flux CD GitOps

## Quick Start

```bash
# Direct deploy
curl -sSL https://raw.githubusercontent.com/AGenNext/Operator-Agents/main/deploy/deployment.yaml | kubectl apply -f -

# GitOps with Flux
curl -sSL https://raw.githubusercontent.com/AGenNext/Operator-Agents/main/deploy/deploy.sh | bash -s flux
```

## Structure

```
agents/luna/           # Luna agent
deploy/
  deploy.sh            # Deploy script
  deployment.yaml       # K8s manifest
flux/
  kustomization.yaml   # Flux GitOps
skills/                 # Skills
```

## Flux CD (CNCF)

```yaml
# flux/kustomization.yaml
apiVersion: source.toolkit.fluxcd.io/v1
kind: GitRepository
---
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
---
apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
```

Deploy: `kubectl apply -f flux/kustomization.yaml`