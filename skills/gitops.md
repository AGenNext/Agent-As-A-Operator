# GitOps Skill

Use Flux CD (CNCF) for GitOps.

## Flux Commands

```bash
flux get all                    # Check status
flux reconcile kustomization luna-agent  # Force sync
flux logs --kind=Kustomization  # View logs
```

## Apply

```bash
kubectl apply -f flux/kustomization.yaml
```

## Values

| Var | Default |
|-----|---------|
| NAMESPACE | headlamp |
| REPLICAS | 2 |