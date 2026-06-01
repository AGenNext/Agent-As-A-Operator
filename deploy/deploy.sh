#!/bin/bash
# Luna Agent - CNCF Native Deploy
# Usage: curl -sSL https://raw.githubusercontent.com/AGenNext/Operator-Agents/main/deploy/deploy.sh | bash
# GitOps: curl -sSL .../deploy.sh | bash -s flux

set -e

NAMESPACE="${NAMESPACE:-headlamp}"
REPLICAS="${REPLICAS:-2}"
MANIFEST="https://raw.githubusercontent.com/AGenNext/Operator-Agents/main/deploy/deployment.yaml"
FLUX="https://raw.githubusercontent.com/AGenNext/Operator-Agents/main/flux/kustomization.yaml"

[ "$1" = "flux" ] && kubectl apply -f "$FLUX" || curl -sSL "$MANIFEST" | kubectl apply -f -
echo "✅ Luna agent deployed to $NAMESPACE"