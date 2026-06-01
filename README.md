# Operator-Agents

> 🤖 Agents who can operate tools - Kubernetes, GitOps, and Cloud Native operations

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)

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

## Agents

### 🌙 Luna - Headlamp AI Pod Manager

**Type:** File-based OpenHands agent  
**Purpose:** Kubernetes pod management with GitOps support

#### Capabilities
- **Kubernetes Operations**: Pod management, deployments, services
- **GitOps**: Flux CD, ArgoCD, Helm, Kustomize
- **MCP Integration**: Flux MCP, Prometheus MCP servers
- **CI/CD**: GitHub Actions pipeline with SBOM
- **IaC**: Terraform configuration

#### Skills
| Skill | Description |
|-------|-------------|
| `kubernetes` | Cluster management, kubectl operations |
| `gitops` | Flux CD, ArgoCD, Helm workflows |
| `semantic-validation` | K8s manifest validation |
| `github` | GitHub integration, PRs |
| `docker` | Container image management |
| `security` | Secure practices, API key handling |

#### Quick Start

```bash
# One-command K3s deployment
curl -sSL https://raw.githubusercontent.com/AGenNext/Operator-Agents/main/deploy/deploy.sh | bash

# Deploy with options
NAMESPACE=production REPLICAS=3 AI_PROVIDER=azure bash deploy.sh
```

#### Stack Components

```
headlamp namespace
├── pod-manager          # FastAPI pod management (2 replicas)
├── flux-mcp-server      # GitOps MCP server
└── prometheus-mcp-server # Metrics MCP server
```

## Project Structure

```
Operator-Agents/
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
│   ├── argocd/                        # ArgoCD tests
│   └── terraform/                     # IaC tests
├── Dockerfile                         # Container build
└── requirements.txt                   # Python dependencies
```

## Deployment Options

| Method | Command | Use Case |
|--------|---------|----------|
| One-liner | `curl -sSL .../deploy.sh \| bash` | Quick start |
| Raw K8s | `kubectl apply -f deployment.yaml` | Custom |
| Helm | `helm install pod-manager oci://...` | Production |
| StackBuilder | `kubectl apply -f stack.yaml` | Full stack |
| Terraform | `terraform apply` | IaC |

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

## Security

- Non-root container (user 1000)
- Read-only filesystem
- No privilege escalation
- Capabilities dropped (ALL)
- NetworkPolicy restrictions
- RBAC least-privilege

## CI/CD

GitHub Actions workflow:
1. Multi-arch build (amd64, arm64)
2. Push to GHCR
3. SBOM generation (SPDX-JSON)
4. Helm chart packaging
5. E2E tests on kind cluster

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