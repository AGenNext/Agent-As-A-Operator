# Headlamp AI Assistant - Pod Manager

> 🤖 Luna-powered Kubernetes pod management with GitOps support

[![Build & Push](https://github.com/headlamp-k8s/plugins/actions/workflows/build-push.yml/badge.svg)](https://github.com/headlamp-k8s/plugins/actions)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)

## Overview

This repository contains the **Luna Agent** and **Pod Manager** for the Headlamp AI Assistant plugin.

```
┌──────────────────────────────────────────────────────────────┐
│                      You (Developer)                         │
└──────────────────────────┬───────────────────────────────────┘
                           │
                           ▼
┌──────────────────────────────────────────────────────────────┐
│                    Luna Agent 🤖                             │
│   "Hey! I'm Luna, your Headlamp AI sidekick."               │
│                                                              │
│   Skills: kubernetes, github, docker, security,            │
│           gitops, semantic-validation                       │
└──────────────────────────┬───────────────────────────────────┘
                           │
              ┌────────────┴────────────┐
              ▼                         ▼
┌─────────────────────┐      ┌─────────────────────────┐
│   Headlamp Plugin   │      │    Pod Manager Service   │
│   (AI Assistant)    │      │    (Runs in K8s)        │
└─────────────────────┘      └─────────────────────────┘
```

## What's Included

### 🌙 Luna Agent (OpenHands)

AI-powered DevOps assistant for Headlamp plugin development.

**Identity:**
- Name: Luna
- Role: Headlamp AI Companion & DevOps Guide
- Personality: Friendly, technically precise, patient teacher

**Skills:**
| Skill | Purpose |
|-------|---------|
| `kubernetes` | Cluster management, kubectl |
| `github` | GitHub integration, PRs |
| `docker` | Container builds |
| `security` | API key handling, secure configs |
| `gitops` | Flux CD, ArgoCD, Helm, Kustomize |
| `semantic-validation` | K8s manifest validation |

### 🚀 One-Command Deployment

Deploy the entire stack to K3s with a single command:

```bash
curl -sSL https://raw.githubusercontent.com/headlamp-k8s/plugins/main/ai-assistant/deploy.sh | bash

# Or with options
NAMESPACE=my-ns REPLICAS=3 AI_PROVIDER=azure bash deploy.sh
```

**Options:**
| Variable | Default | Description |
|----------|---------|-------------|
| `NAMESPACE` | `headlamp` | Target namespace |
| `REPLICAS` | `2` | Pod Manager replicas |
| `AI_PROVIDER` | `openai` | AI provider (openai, azure, anthropic, deepseek, ollama) |
| `VERSION` | `latest` | Image version/tag |

### ☸ Kubernetes Stack

```
headlamp namespace
├── Pod Manager (2 replicas)
│   ├── Service: pod-manager:8080
│   ├── ServiceAccount: pod-manager
│   ├── Role: pod-manager (RBAC)
│   └── RoleBinding: pod-manager
├── Flux MCP Server
│   └── Service: flux-mcp-server:8081
├── Prometheus MCP Server
│   └── Service: prometheus-mcp-server:8082
└── NetworkPolicy
    └── egress: 443, 80 | ingress: headlamp ns
```

### 📦 Container Image

**GHCR:** `ghcr.io/headlamp-k8s/plugins/pod-manager`

| Tag | Description |
|-----|-------------|
| `latest` | Most recent build |
| `v1.0.0` | Semantic version |
| `sha-xxxxxxx` | Git commit |

**Multi-arch:** `linux/amd64`, `linux/arm64`

### 🎯 Helm Chart

```bash
# Add repo (after merge)
helm repo add headlamp https://headlamp-k8s.github.io/plugins

# Install
helm install pod-manager headlamp/pod-manager \
  --namespace headlamp \
  --create-namespace \
  --set replicaCount=2 \
  --set config.aiProvider=openai
```

### 📊 E2E Testing

```bash
# Run all tests
./e2e/run-tests.sh

# ArgoCD tests
./e2e/argocd/run-argocd-tests.sh

# Terraform validation
./e2e/terraform/run-terraform-tests.sh
```

**Test coverage:**
- 20+ bash tests for manifests, skills, agent
- ArgoCD sync & health verification
- Terraform HCL validation

## Project Structure

```
ai-assistant/
├── agents/
│   └── headlamp-ai-assistant.md    # Luna agent definition
├── .skills/
│   ├── gitops.md                   # GitOps documentation
│   └── semantic-validation.md      # K8s validation rules
├── pod-manager/
│   ├── k8s/
│   │   └── deployment.yaml         # Raw K8s manifests
│   ├── helm/
│   │   └── pod-manager/            # Helm chart
│   └── stackbuilder/
│       └── stack.yaml              # Full stack manifest
├── src/pod_manager/
│   └── main.py                     # FastAPI application
├── e2e/
│   ├── run-tests.sh                # Bash E2E tests
│   ├── argocd/                     # ArgoCD tests
│   └── terraform/                  # IaC tests
├── .github/workflows/
│   └── build-push.yml              # CI/CD pipeline
├── deploy.sh                       # One-command deploy
├── uninstall.sh                     # Cleanup script
├── Dockerfile                      # Container build
└── requirements.txt                # Python dependencies
```

## CI/CD Pipeline

GitHub Actions workflow builds and pushes on every push to `main`:

```yaml
1. Checkout code
2. Set up QEMU + Docker Buildx
3. Login to GHCR
4. Build & push multi-arch image
5. Generate SBOM (SPDX-JSON)
6. Upload SBOM artifact (30-day retention)
7. Package Helm chart
8. Run E2E tests on kind cluster
```

**Outputs:**
- Container: `ghcr.io/headlamp-k8s/plugins/pod-manager`
- Helm: `ghcr.io/headlamp-k8s/plugins/pod-manager-chart`
- SBOM: `sbom.spdx.json`

## SBOM (Software Bill of Materials)

Every build generates an SPDX-JSON SBOM tracking:
- Container layers
- Python dependencies
- Vulnerabilities
- License compliance

Compatible with:
- [Trivy](https://aquasecurity.github.io/trivy/)
- [Grype](https://github.com/anchore/grype)
- [Dependency Track](https://dependencytrack.org/)

## Quick Start

### 1. Deploy to K3s
```bash
curl -sSL https://raw.githubusercontent.com/headlamp-k8s/plugins/main/ai-assistant/deploy.sh | bash
```

### 2. Verify Deployment
```bash
kubectl get all -n headlamp

# Expected output:
# NAME                                    READY   STATUS
# deployment.apps/pod-manager            2/2     Running
# deployment.apps/flux-mcp-server       1/1     Running
# deployment.apps/prometheus-mcp-server  1/1     Running
```

### 3. Access Services
```bash
# Pod Manager
kubectl port-forward -n headlamp svc/pod-manager 8080:8080

# Flux MCP
kubectl port-forward -n headlamp svc/flux-mcp-server 8081:8081

# Prometheus MCP
kubectl port-forward -n headlamp svc/prometheus-mcp-server 8082:8082
```

### 4. Cleanup
```bash
curl -sSL https://raw.githubusercontent.com/headlamp-k8s/plugins/main/ai-assistant/uninstall.sh | bash
# Or: kubectl delete namespace headlamp
```

## Luna Agent Usage

Ask Luna to help with:

```text
"Help me set up the AI Assistant plugin"
"Configure OpenAI and Azure providers"
"Deploy HolmesGPT to my Kubernetes cluster"
"Set up MCP servers for Flux and other tools"
"Debug AI Assistant chat UI issues"
"Validate my Kubernetes manifests"
"Set up GitOps with Flux CD"
```

## Configuration

### AI Provider Setup

| Provider | Environment Variables |
|----------|----------------------|
| OpenAI | `OPENAI_API_KEY` |
| Azure | `AZURE_API_KEY`, `AZURE_API_BASE`, `AZURE_API_VERSION` |
| Anthropic | `ANTHROPIC_API_KEY` |
| DeepSeek | `DEEPSEEK_API_KEY` |
| Ollama | `OLLAMA_BASE_URL` (default: http://localhost:11434) |

### MCP Servers

Configure in `values.yaml`:
```yaml
mcp:
  enabled: true
  servers:
    - name: flux
      command: flux-operator-mcp
      args: ["serve", "--kube-context", "HEADLAMP_CURRENT_CLUSTER"]
    - name: prometheus
      command: prometheus-mcp
      env:
        PROMETHEUS_URL: http://prometheus.monitoring:9090
```

## Security

- **Non-root container**: Runs as user 1000
- **Read-only filesystem**: `readOnlyRootFilesystem: true`
- **No privilege escalation**: `allowPrivilegeEscalation: false`
- **Capabilities dropped**: `ALL`
- **NetworkPolicy**: Restricted ingress/egress
- **RBAC**: Least-privilege service account

## Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature/my-feature`
3. Commit changes: `git commit -m 'feat: add my feature'`
4. Push: `git push origin feature/my-feature`
5. Open PR to `main` branch

## License

Apache 2.0 - see [LICENSE](LICENSE)

---

Built with 🤖 Luna and ☸ Kubernetes