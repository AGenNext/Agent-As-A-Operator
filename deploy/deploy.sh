#!/bin/bash
# One-command K3s deployment for Headlamp AI Assistant
# Usage: curl -sSL https://raw.githubusercontent.com/headlamp-k8s/plugins/main/ai-assistant/deploy.sh | bash

set -e

VERSION="${VERSION:-latest}"
NAMESPACE="${NAMESPACE:-headlamp}"
REPLICAS="${REPLICAS:-2}"
AI_PROVIDER="${AI_PROVIDER:-openai}"

echo "=========================================="
echo "Headlamp AI Assistant - K3s Deployment"
echo "=========================================="
echo "Namespace: $NAMESPACE"
echo "Replicas: $REPLICAS"
echo "AI Provider: $AI_PROVIDER"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "${YELLOW}→${NC} $1"; }
done() { echo -e "${GREEN}✓${NC} $1"; }

# Detect k3s vs standard k8s
if command -v k3s &>/dev/null; then
    KUBE_CMD="sudo k3s"
else
    KUBE_CMD="kubectl"
fi

info "Checking Kubernetes access..."
if ! $KUBE_CMD cluster-info &>/dev/null; then
    echo "Error: Cannot access Kubernetes cluster"
    exit 1
fi
done "Kubernetes cluster accessible"

# Create namespace
info "Creating namespace..."
$KUBE_CMD create namespace "$NAMESPACE" --dry-run=client -o yaml | $KUBE_CMD apply -f - >/dev/null 2>&1 || true
done "Namespace '$NAMESPACE' ready"

# Apply stack directly
info "Deploying Headlamp AI Stack..."
$KUBE_CMD apply -n "$NAMESPACE" -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: $NAMESPACE
  labels:
    app.kubernetes.io/name: headlamp-ai
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: headlamp-ai-config
  namespace: $NAMESPACE
data:
  AI_PROVIDER: "$AI_PROVIDER"
  LOG_LEVEL: "info"
  ENABLE_MCP: "true"
  STACK_VERSION: "$VERSION"
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: pod-manager
  namespace: $NAMESPACE
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-manager
  namespace: $NAMESPACE
rules:
  - apiGroups: [""]
    resources: ["pods", "pods/log", "pods/exec", "services", "configmaps", "secrets"]
    verbs: ["get", "list", "watch", "create", "delete", "patch", "update"]
  - apiGroups: [""]
    resources: ["namespaces", "nodes"]
    verbs: ["get", "list"]
  - apiGroups: ["apps"]
    resources: ["deployments", "replicasets", "statefulsets", "daemonsets"]
    verbs: ["get", "list", "watch", "update"]
  - apiGroups: ["batch"]
    resources: ["jobs", "cronjobs"]
    verbs: ["get", "list"]
  - apiGroups: ["networking.k8s.io"]
    resources: ["ingresses", "networkpolicies"]
    verbs: ["get", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: pod-manager
  namespace: $NAMESPACE
subjects:
  - kind: ServiceAccount
    name: pod-manager
    namespace: $NAMESPACE
roleRef:
  kind: Role
  name: pod-manager
  apiGroup: rbac.authorization.k8s.io
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: pod-manager
  namespace: $NAMESPACE
  labels:
    app: pod-manager
    tier: ai
spec:
  replicas: $REPLICAS
  selector:
    matchLabels:
      app: pod-manager
  template:
    metadata:
      labels:
        app: pod-manager
        tier: ai
    spec:
      serviceAccountName: pod-manager
      containers:
        - name: pod-manager
          image: ghcr.io/headlamp-k8s/plugins/pod-manager:$VERSION
          imagePullPolicy: IfNotPresent
          ports:
            - containerPort: 8080
              name: http
          envFrom:
            - configMapRef:
                name: headlamp-ai-config
          env:
            - name: HEADLAMP_CURRENT_CLUSTER
              valueFrom:
                fieldRef:
                  fieldPath: metadata.clusterName
          resources:
            requests:
              cpu: 100m
              memory: 128Mi
            limits:
              cpu: 500m
              memory: 512Mi
          readinessProbe:
            httpGet:
              path: /ready
              port: 8080
            initialDelaySeconds: 5
            periodSeconds: 5
          livenessProbe:
            httpGet:
              path: /health
              port: 8080
            initialDelaySeconds: 30
            periodSeconds: 10
          securityContext:
            readOnlyRootFilesystem: true
            allowPrivilegeEscalation: false
            capabilities:
              drop: ["ALL"]
---
apiVersion: v1
kind: Service
metadata:
  name: pod-manager
  namespace: $NAMESPACE
spec:
  type: ClusterIP
  ports:
    - port: 8080
      targetPort: 8080
      name: http
  selector:
    app: pod-manager
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: pod-manager
  namespace: $NAMESPACE
spec:
  podSelector:
    matchLabels:
      app: pod-manager
  policyTypes:
    - Ingress
    - Egress
  ingress:
    - from:
        - namespaceSelector:
            matchLabels:
              kubernetes.io/metadata.name: $NAMESPACE
  egress:
    - ports:
        - protocol: TCP
          port: 443
        - protocol: TCP
          port: 80
---
# Flux MCP Server
apiVersion: apps/v1
kind: Deployment
metadata:
  name: flux-mcp-server
  namespace: $NAMESPACE
  labels:
    app: flux-mcp-server
    tier: mcp
spec:
  replicas: 1
  selector:
    matchLabels:
      app: flux-mcp-server
  template:
    metadata:
      labels:
        app: flux-mcp-server
        tier: mcp
    spec:
      containers:
        - name: flux-mcp
          image: ghcr.io/fluxcd/flux-operator-mcp:latest
          ports:
            - containerPort: 8081
          resources:
            requests:
              cpu: 50m
              memory: 64Mi
            limits:
              cpu: 200m
              memory: 256Mi
---
apiVersion: v1
kind: Service
metadata:
  name: flux-mcp-server
  namespace: $NAMESPACE
spec:
  type: ClusterIP
  ports:
    - port: 8081
      targetPort: 8081
  selector:
    app: flux-mcp-server
---
# Prometheus MCP Server
apiVersion: apps/v1
kind: Deployment
metadata:
  name: prometheus-mcp-server
  namespace: $NAMESPACE
  labels:
    app: prometheus-mcp-server
    tier: mcp
spec:
  replicas: 1
  selector:
    matchLabels:
      app: prometheus-mcp-server
  template:
    metadata:
      labels:
        app: prometheus-mcp-server
        tier: mcp
    spec:
      containers:
        - name: prometheus-mcp
          image: ghcr.io/prometheus-community/prometheus-mcp:latest
          ports:
            - containerPort: 8082
          resources:
            requests:
              cpu: 50m
              memory: 64Mi
            limits:
              cpu: 200m
              memory: 256Mi
---
apiVersion: v1
kind: Service
metadata:
  name: prometheus-mcp-server
  namespace: $NAMESPACE
spec:
  type: ClusterIP
  ports:
    - port: 8082
      targetPort: 8082
  selector:
    app: prometheus-mcp-server
EOF

done "Stack deployed!"

# Wait for rollout
info "Waiting for deployments..."
$KUBE_CMD rollout status deployment/pod-manager -n "$NAMESPACE" --timeout=60s
$KUBE_CMD rollout status deployment/flux-mcp-server -n "$NAMESPACE" --timeout=60s
$KUBE_CMD rollout status deployment/prometheus-mcp-server -n "$NAMESPACE" --timeout=60s
done "All deployments ready"

# Show status
echo ""
echo "=========================================="
echo "Deployment Complete!"
echo "=========================================="
echo ""
$KUBE_CMD get all -n "$NAMESPACE"
echo ""
info "Pod Manager: http://pod-manager.$NAMESPACE.svc:8080"
info "Flux MCP: flux-mcp-server.$NAMESPACE.svc:8081"
info "Prometheus MCP: prometheus-mcp-server.$NAMESPACE.svc:8082"
echo ""