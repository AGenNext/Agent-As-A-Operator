# Operator-Agents

> 🤖 Agents who can operate tools - Kubernetes, GitOps, and Cloud Native operations

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![Flux CD](https://img.shields.io/badge/Flux_CD-1B5E20?style=for-the-badge&logo=git)](https://fluxcd.io/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-326ce5?style=for-the-badge&logo=kubernetes)](https://kubernetes.io/)

## Overview

This repository contains **Operator Agents** - AI agents designed to operate tools and manage cloud-native infrastructure.

```
┌────────────────────────────────────────────────────────────┐
│                    Operator Agents                         │
├────────────────────────────────────────────────────────────┤
│                                                            │
│   🌙 Luna          │   Agent that operates Kubernetes    │
│   (Headlamp AI)    │   and GitOps tools                   │
│                                                            │
│   ┌────────────┐   ┌────────────┐   ┌────────────┐        │
│   │ k8s       │   │ gitops    │   │ mcp        │        │
│   │ kubectl   │   │ Flux/Argo │   │ servers   │        │
│   └────────────┘   └────────────┘   └────────────┘        │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

## Quick Start

```bash
# One-command K3s deployment
curl -sSL https://raw.githubusercontent.com/AGenNext/Operator-Agents/main/deploy/deploy.sh | bash

# Deploy with options
NAMESPACE=production REPLICAS=3 AI_PROVIDER=azure bash deploy.sh
```

## Agent Registry

| Agent | Type | Purpose |
|-------|------|---------|
| 🌙 **Luna** | Operator | Kubernetes pod management & GitOps |

### 🌙 Luna - Headlamp AI Pod Manager

**Type:** File-based OpenHands agent  
**Purpose:** Kubernetes pod management with GitOps support

```yaml
name: Luna
role: Headlamp AI Companion & DevOps Guide
skills: kubernetes, gitops, security, docker, github, semantic-validation
providers: openai, azure, anthropic, deepseek, ollama
```

#### Capabilities

| Capability | Description |
|------------|-------------|
| ☸ Kubernetes | Pod management, deployments, services |
| 🔄 GitOps | Flux CD, ArgoCD, Helm, Kustomize |
| 🛡️ Security | RBAC, NetworkPolicy, secure defaults |
| 📦 Docker | Multi-arch container builds |
| 🔍 Validation | K8s manifest validation |
| 🐙 GitHub | PR management, CI/CD |

#### Stack Components

```
headlamp namespace
├── pod-manager          # FastAPI pod management (2 replicas)
├── flux-mcp-server      # GitOps MCP server
└── prometheus-mcp-server # Metrics MCP server
```

## Deployment Options

| Method | Command | Use Case |
|--------|---------|----------|
| One-liner | `curl -sSL .../deploy.sh \| bash` | Quick start |
| Raw K8s | `kubectl apply -f deploy/deployment.yaml` | Custom |
| StackBuilder | `kubectl apply -f deploy/stack.yaml` | Full stack |
| Helm | `helm install pod-manager oci://...` | Production |
| Terraform | `terraform apply` | IaC |
| Flux CD | See [Flux Sync](#flux-sync) | GitOps |

## Flux CD Sync

Sync Luna agent configuration across multiple repositories using Flux CD:

```bash
# Install Flux on your cluster
flux install --components=source-controller,kustomize-controller,helm-controller

# Apply Flux configuration
kubectl apply -f flux/

# Check status
flux get all
```

### Flux Multi-Repo Sync Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Flux CD                                  │
│              (GitOps Toolkit)                               │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  GitRepository ──────────────────────────────────────┐     │
│  (Operator-Agents source)                             │     │
│       │                                               │     │
│       ├──► Kustomization (deploy) ──┐               │     │
│       │                               ▼               │     │
│       │                         headlamp namespace    │     │
│       │                               │               │     │
│       ├──► Kustomization (sync) ────▼─────────────────┼───►│
│       │                               │               │     │
│       │                    ┌───────────┴───────────┐  │     │
│       │                    │                       │  │     │
│       │                    ▼                       ▼  │     │
│       │            ┌─────────────┐    ┌─────────────┐│     │
│       │            │ Agent-Services│   │ DevOps      ││     │
│       │            │ AGENTS.md   │    │ AGENTS.md   ││     │
│       │            └─────────────┘    └─────────────┘│     │
│       │                                               │     │
│       └──► HelmRelease (pod-manager)                  │     │
│                   (helm chart)                        │     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Flux Components

| Component | Purpose |
|-----------|---------|
| `flux/source.yaml` | GitRepository for source repo |
| `flux/sync.yaml` | Kustomization for deployments |
| `flux/repos.yaml` | Multi-repo sync configuration |
| `flux/helm.yaml` | HelmRelease for pod-manager |

### Target Repositories

| Repository | Content | Branch |
|------------|----------|--------|
| `AGenNext/Operator-Agents` | Source agent definition | `main` |
| `AGenNext/Agent-Services` | AI provider integration | `main` |
| `AGenNext/AGenNext-DevOps` | DevOps capabilities | `main` |
| `headlamp-k8s/plugins` | Headlamp plugin | `feature/pod-manager-agent` |

## Project Structure

```
Operator-Agents/
├── README.md                           # This file
├── AGENT_CARD.md                       # Agent card (JSON, HTML)
├── CARD.md                            # Visual card with badges
├── agents/
│   └── luna/
│       └── headlamp-ai-assistant.md    # Luna agent definition
├── skills/
│   ├── gitops.md                       # GitOps documentation
│   └── semantic-validation.md          # K8s validation rules
├── deploy/
│   ├── deploy.sh                      # One-command deploy
│   ├── uninstall.sh                   # Cleanup script
│   ├── deployment.yaml                # Raw K8s manifest
│   └── stack.yaml                     # StackBuilder manifest
├── e2e/
│   ├── run-tests.sh                   # Bash E2E tests
│   ├── main.tf                        # Terraform
│   └── flux-app.yaml                  # Flux sync test
├── flux/
│   ├── source.yaml              # GitRepository source
│   ├── sync.yaml                # Kustomization + ImagePolicy
│   ├── repos.yaml               # Multi-repo sync
│   └── helm.yaml                # HelmRelease for pod-manager
├── Dockerfile                         # Container build
└── requirements.txt                   # Python dependencies
```

## Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `NAMESPACE` | `headlamp` | Target namespace |
| `REPLICAS` | `2` | Pod replicas |
| `AI_PROVIDER` | `openai` | AI provider |
| `VERSION` | `latest` | Image tag |

### AI Providers

| Provider | Env Vars |
|----------|----------|
| OpenAI | `OPENAI_API_KEY` |
| Azure | `AZURE_API_KEY`, `AZURE_API_BASE` |
| Anthropic | `ANTHROPIC_API_KEY` |
| Ollama | `OLLAMA_BASE_URL` |

## Testing

```bash
# Run all E2E tests
./e2e/run-tests.sh

# ArgoCD sync tests
./e2e/argocd/run-argocd-tests.sh

# Terraform validation
./e2e/terraform/run-terraform-tests.sh
```

## CI/CD Pipeline

GitHub Actions workflow:
1. Multi-arch build (amd64, arm64)
2. Push to GHCR
3. SBOM generation (SPDX-JSON)
4. Helm chart packaging
5. E2E tests on kind cluster

## Security

- Non-root container (user 1000)
- Read-only filesystem
- No privilege escalation
- Capabilities dropped (ALL)
- NetworkPolicy restrictions
- RBAC least-privilege

## Contributing

1. Fork this repository
2. Add agent in `agents/<agent-name>/`
3. Add skills in `skills/`
4. Add deployment options in `deploy/`
5. Add tests in `e2e/`
6. Submit PR

## License

Apache 2.0 - see [LICENSE](LICENSE)

---

Built with 🤖 OpenHands Operator Agents