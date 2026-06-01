#!/bin/bash
# One-command cleanup for Headlamp AI Assistant
# Usage: curl -sSL https://raw.githubusercontent.com/headlamp-k8s/plugins/main/ai-assistant/uninstall.sh | bash

NAMESPACE="${NAMESPACE:-headlamp}"

echo "Removing Headlamp AI Stack from namespace: $NAMESPACE"

if command -v k3s &>/dev/null; then
    KUBE_CMD="sudo k3s"
else
    KUBE_CMD="kubectl"
fi

$KUBE_CMD delete namespace "$NAMESPACE" --ignore-not-found=true

echo "✓ Cleanup complete"