#!/bin/bash
# End-to-End Tests for Headlamp AI Assistant Agent

set -e

echo "=========================================="
echo "Headlamp AI Assistant - E2E Test Suite"
echo "=========================================="

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counters
TESTS_PASSED=0
TESTS_FAILED=0

# Helper functions
pass() {
    echo -e "${GREEN}✓ PASS${NC}: $1"
    ((TESTS_PASSED++))
}

fail() {
    echo -e "${RED}✗ FAIL${NC}: $1"
    ((TESTS_FAILED++))
}

info() {
    echo -e "${YELLOW}→ INFO${NC}: $1"
}

section() {
    echo ""
    echo "=========================================="
    echo "Testing: $1"
    echo "=========================================="
}

# ========================================
# AGENT TESTS
# ========================================
section "Agent Configuration Tests"

# Test 1: Agent file exists
if [ -f "agents/headlamp-ai-assistant.md" ]; then
    pass "Agent file exists"
else
    fail "Agent file missing"
fi

# Test 2: Agent has identity
if grep -q "Name: Luna" agents/headlamp-ai-assistant.md; then
    pass "Agent has identity (Luna)"
else
    fail "Agent identity missing"
fi

# Test 3: Agent has required skills
for skill in kubernetes github docker security gitops semantic-validation; do
    if grep -q "  - $skill" agents/headlamp-ai-assistant.md; then
        pass "Agent has $skill skill"
    else
        fail "Agent missing $skill skill"
    fi
done

# Test 4: Agent has tools defined
if grep -q "tools:" agents/headlamp-ai-assistant.md; then
    pass "Agent has tools defined"
else
    fail "Agent tools not defined"
fi

# Test 5: Agent has greeting
if grep -q "Greeting:" agents/headlamp-ai-assistant.md; then
    pass "Agent has greeting"
else
    fail "Agent greeting missing"
fi

# ========================================
# SKILL TESTS
# ========================================
section "Skill Tests"

# Test 6: GitOps skill exists
if [ -f ".skills/gitops.md" ]; then
    pass "GitOps skill exists"
    # Check for key content
    if grep -q "Flux CD" .skills/gitops.md; then
        pass "GitOps skill has Flux content"
    else
        fail "GitOps skill missing Flux content"
    fi
else
    fail "GitOps skill missing"
fi

# Test 7: Semantic validation skill exists
if [ -f ".skills/semantic-validation.md" ]; then
    pass "Semantic validation skill exists"
    if grep -q "KUBERNETES" .skills/semantic-validation.md || grep -q "Kubernetes" .skills/semantic-validation.md; then
        pass "Semantic validation skill has K8s content"
    else
        fail "Semantic validation skill missing K8s content"
    fi
else
    fail "Semantic validation skill missing"
fi

# ========================================
# KUBERNETES MANIFEST TESTS
# ========================================
section "Kubernetes Manifest Tests"

# Test 8: K8s deployment exists
if [ -f "pod-manager/k8s/deployment.yaml" ]; then
    pass "K8s deployment manifest exists"
else
    fail "K8s deployment manifest missing"
fi

# Test 9: Deployment has required resources
for resource in Namespace Deployment Service ServiceAccount Role RoleBinding; do
    if grep -q "^kind: $resource" pod-manager/k8s/deployment.yaml; then
        pass "Manifest has $resource"
    else
        fail "Manifest missing $resource"
    fi
done

# Test 10: RBAC has correct verbs
if grep -q "pods" pod-manager/k8s/deployment.yaml && grep -q "get.*list.*watch" pod-manager/k8s/deployment.yaml; then
    pass "RBAC has pod permissions"
else
    fail "RBAC permissions incomplete"
fi

# Test 11: Security context configured
if grep -q "runAsNonRoot" pod-manager/k8s/deployment.yaml; then
    pass "Security context configured"
else
    fail "Security context missing"
fi

# Test 12: Liveness/readiness probes
if grep -q "livenessProbe" pod-manager/k8s/deployment.yaml && grep -q "readinessProbe" pod-manager/k8s/deployment.yaml; then
    pass "Health probes configured"
else
    fail "Health probes missing"
fi

# ========================================
# HELM CHART TESTS
# ========================================
section "Helm Chart Tests"

# Test 13: Helm chart exists
if [ -f "pod-manager/helm/pod-manager/Chart.yaml" ]; then
    pass "Helm Chart.yaml exists"
else
    fail "Helm Chart.yaml missing"
fi

# Test 14: Values file exists
if [ -f "pod-manager/helm/pod-manager/values.yaml" ]; then
    pass "Helm values.yaml exists"
else
    fail "Helm values.yaml missing"
fi

# Test 15: Chart has apiVersion v2
if grep -q "apiVersion: v2" pod-manager/helm/pod-manager/Chart.yaml; then
    pass "Helm chart uses apiVersion v2"
else
    fail "Helm chart apiVersion incorrect"
fi

# Test 16: Templates exist
for template in _helpers.tpl namespace.yaml configmap.yaml; do
    if [ -f "pod-manager/helm/pod-manager/templates/$template" ]; then
        pass "Template $template exists"
    else
        fail "Template $template missing"
    fi
done

# ========================================
# STACKBUILDER TESTS
# ========================================
section "StackBuilder Tests"

# Test 17: Stack manifest exists
if [ -f "pod-manager/stackbuilder/stack.yaml" ]; then
    pass "Stack manifest exists"
else
    fail "Stack manifest missing"
fi

# Test 18: Stack has MCP servers
if grep -q "flux-mcp-server" pod-manager/stackbuilder/stack.yaml && grep -q "prometheus-mcp-server" pod-manager/stackbuilder/stack.yaml; then
    pass "Stack has MCP servers (flux, prometheus)"
else
    fail "Stack MCP servers missing"
fi

# Test 19: Stack has NetworkPolicy
if grep -q "NetworkPolicy" pod-manager/stackbuilder/stack.yaml; then
    pass "Stack has NetworkPolicy"
else
    fail "Stack NetworkPolicy missing"
fi

# Test 20: Stack has ConfigMap
if grep -q "kind: ConfigMap" pod-manager/stackbuilder/stack.yaml; then
    pass "Stack has ConfigMap"
else
    fail "Stack ConfigMap missing"
fi

# ========================================
# YAML VALIDATION TESTS
# ========================================
section "YAML Validation Tests"

# Test 21: All YAML files are valid
for yaml in $(find pod-manager -name "*.yaml"); do
    if command -v python3 &> /dev/null; then
        if python3 -c "import yaml; yaml.safe_load(open('$yaml'))" 2>/dev/null; then
            pass "Valid YAML: $yaml"
        else
            fail "Invalid YAML: $yaml"
        fi
    else
        info "Python3 not available, skipping YAML validation"
        break
    fi
done

# ========================================
# SUMMARY
# ========================================
section "Test Summary"
echo ""
echo "Results:"
echo "  Passed: $TESTS_PASSED"
echo "  Failed: $TESTS_FAILED"
echo "  Total:  $((TESTS_PASSED + TESTS_FAILED))"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}=========================================="
    echo "All tests passed! ✓"
    echo "==========================================${NC}"
    exit 0
else
    echo -e "${RED}=========================================="
    echo "Some tests failed. ✗"
    echo "==========================================${NC}"
    exit 1
fi