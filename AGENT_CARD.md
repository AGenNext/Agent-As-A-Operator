# 🌙 Luna - Agent Card

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│     🌙  LUNA                                                 │
│     Headlamp AI Pod Manager                                 │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐       │
│  │  ☸     │  │  🔄    │  │  🛡️    │  │  📦    │       │
│  │ k8s    │  │ gitops │  │ security│  │ docker │       │
│  └─────────┘  └─────────┘  └─────────┘  └─────────┘       │
│                                                             │
│  ┌─────────┐  ┌─────────┐                                 │
│  │  🔍    │  │  🐙    │                                 │
│  │ semval │  │ github  │                                 │
│  └─────────┘  └─────────┘                                 │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  TYPE:       Operator Agent (File-based)                   │
│  PLATFORM:   OpenHands                                      │
│  LANGUAGE:   Markdown, Python                               │
│                                                             │
│  SKILLS:     6 (kubernetes, gitops, security,              │
│              docker, semantic-validation, github)           │
│                                                             │
│  LANGUAGES:  English                                        │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  CAPABILITIES:                                              │
│  ✓ One-command K3s deployment                               │
│  ✓ Kubernetes pod management                                │
│  ✓ GitOps (Flux CD, ArgoCD, Helm)                          │
│  ✓ MCP server integration                                   │
│  ✓ CI/CD pipeline management                                │
│  ✓ Terraform IaC                                            │
│  ✓ SBOM generation                                          │
│  ✓ E2E testing                                             │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  AI PROVIDERS:                                              │
│  • OpenAI      • Azure     • Anthropic                      │
│  • DeepSeek    • Ollama                                     │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  DEPLOY:                                                    │
│  curl -sSL .../deploy.sh | bash                            │
│                                                             │
│  REPO: github.com/AGenNext/Operator-Agents                 │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Markdown Card

```markdown
| 🌙 Luna | Kubernetes Agent |
|--------|-------------------|
| **Type** | Operator Agent |
| **Platform** | OpenHands |
| **Skills** | k8s, gitops, security, docker, github |
| **Deploy** | `curl -sSL .../deploy.sh \| bash` |
| **Repo** | [AGenNext/Operator-Agents](https://github.com/AGenNext/Operator-Agents) |
```

## JSON Card

```json
{
  "name": "Luna",
  "title": "Headlamp AI Pod Manager",
  "type": "operator",
  "platform": "openhands",
  "avatar": "🌙",
  "skills": [
    {"name": "kubernetes", "icon": "☸", "level": "expert"},
    {"name": "gitops", "icon": "🔄", "level": "expert"},
    {"name": "security", "icon": "🛡️", "level": "advanced"},
    {"name": "docker", "icon": "📦", "level": "advanced"},
    {"name": "semantic-validation", "icon": "🔍", "level": "advanced"},
    {"name": "github", "icon": "🐙", "level": "advanced"}
  ],
  "capabilities": [
    "One-command K3s deployment",
    "Kubernetes pod management",
    "GitOps (Flux, ArgoCD, Helm)",
    "MCP server integration",
    "CI/CD pipeline management",
    "Terraform IaC",
    "SBOM generation",
    "E2E testing"
  ],
  "providers": ["openai", "azure", "anthropic", "deepseek", "ollama"],
  "deployment": {
    "method": "curl -sSL .../deploy.sh | bash",
    "namespace": "headlamp",
    "replicas": 2
  },
  "repository": "https://github.com/AGenNext/Operator-Agents"
}
```

## HTML Card

```html
<div class="agent-card luna">
  <div class="avatar">🌙</div>
  <h2>Luna</h2>
  <p class="title">Headlamp AI Pod Manager</p>
  
  <div class="skills">
    <span class="skill" title="Kubernetes">☸ k8s</span>
    <span class="skill" title="GitOps">🔄 gitops</span>
    <span class="skill" title="Security">🛡️ security</span>
    <span class="skill" title="Docker">📦 docker</span>
    <span class="skill" title="Validation">🔍 semval</span>
    <span class="skill" title="GitHub">🐙 github</span>
  </div>
  
  <div class="deploy">
    <code>curl -sSL .../deploy.sh | bash</code>
  </div>
  
  <a href="https://github.com/AGenNext/Operator-Agents" class="btn">
    View Repository →
  </a>
</div>
```

## Usage

```bash
# Deploy Luna to your K3s cluster
curl -sSL https://raw.githubusercontent.com/AGenNext/Operator-Agents/main/deploy/deploy.sh | bash

# Or with options
NAMESPACE=production REPLICAS=3 AI_PROVIDER=azure bash deploy.sh
```

---

**Last Updated:** 2026-05-30  
**Agent ID:** luna-headlamp-ai-pod-manager  
**Version:** 1.0.0