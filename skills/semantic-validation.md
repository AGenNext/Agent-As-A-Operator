# Semantic Validation Skill

Validate K8s manifests before apply.

## Rules

```yaml
# Required labels
metadata.labels.app: required
metadata.labels.version: required

# Required fields
spec.selector.matchLabels: required
spec.template.metadata.labels: required

# Security
spec.template.spec.securityContext: required
containers[].securityContext: required
```

## Validate

```bash
kubectl apply --dry-run=server -f manifest.yaml
```