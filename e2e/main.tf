# Main Terraform configuration for Headlamp AI Stack

# ArgoCD Application
resource "argocd_application" "headlamp_ai" {
  metadata {
    name      = "headlamp-ai"
    namespace = "argocd"
    labels = {
      app = "headlamp-ai"
      tier = "ai"
    }
  }

  spec {
    project = "default"

    source {
      repo_url        = var.repo_url
      target_revision = var.target_revision
      path            = var.app_path
      kustomize {
        name_prefix = var.namespace
      }
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = var.namespace
    }

    sync_policy {
      automated {
        prune      = true
        self_heal  = true
        allow_empty = false
      }

      retry {
        limit = 5
        backoff {
          duration    = "5s"
          factor      = 2
          max_duration = "3m"
        }
      }

      sync_options = [
        "CreateNamespace=true",
        "PrunePropagation=foreground",
        "PruneLast=true"
      ]
    }

    ignore_difference {
      group = "apps"
      kind  = "Deployment"
      json_pointers = ["/spec/replicas"]
    }

    revision_history_limit = 10
  }

  depends_on = [helm_release.argo_rollouts]
}

# Helm Release for ArgoCD Rollouts (canary deployments)
resource "helm_release" "argo_rollouts" {
  name       = "argo-rollouts"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-rollouts"
  version    = "2.0.0"
  namespace  = "argocd"

  set {
    name  = "controller.replicas"
    value = var.replica_count
  }

  set {
    name  = "namespace"
    value = var.namespace
  }
}

# Namespace
resource "kubernetes_namespace" "headlamp" {
  metadata {
    name = var.namespace

    labels = {
      app.kubernetes.io/name    = "headlamp-ai"
      app.kubernetes.io/part-of = "headlamp"
      environment              = var.environment
    }
  }
}

# ConfigMap
resource "kubernetes_config_map" "ai_config" {
  metadata {
    name      = "headlamp-ai-config"
    namespace = var.namespace
  }

  data = {
    AI_PROVIDER = var.ai_provider
    LOG_LEVEL   = var.log_level
    ENABLE_MCP  = tostring(var.enable_mcp)
  }

  depends_on = [kubernetes_namespace.headlamp]
}

# Service Account
resource "kubernetes_service_account" "pod_manager" {
  metadata {
    name      = "pod-manager"
    namespace = var.namespace
  }

  depends_on = [kubernetes_namespace.headlamp]
}

# Role
resource "kubernetes_role" "pod_manager" {
  metadata {
    name      = "pod-manager"
    namespace = var.namespace
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "pods/log", "pods/exec", "services", "configmaps"]
    verbs      = ["get", "list", "watch", "create", "delete", "patch", "update"]
  }

  rule {
    api_groups = [""]
    resources  = ["namespaces", "nodes"]
    verbs      = ["get", "list"]
  }

  rule {
    api_groups = ["apps"]
    resources  = ["deployments", "replicasets", "statefulsets"]
    verbs      = ["get", "list", "watch"]
  }

  depends_on = [kubernetes_namespace.headlamp]
}

# Role Binding
resource "kubernetes_role_binding" "pod_manager" {
  metadata {
    name      = "pod-manager"
    namespace = var.namespace
  }

  subject {
    kind      = "ServiceAccount"
    name      = "pod-manager"
    namespace = var.namespace
  }

  role_ref {
    kind = "Role"
    name = "pod-manager"
  }

  depends_on = [kubernetes_role.pod_manager]
}

# Deployment
resource "kubernetes_deployment" "pod_manager" {
  metadata {
    name      = "pod-manager"
    namespace = var.namespace
    labels = {
      app = "pod-manager"
      tier = "ai"
    }
  }

  spec {
    replicas = var.replica_count

    selector {
      match_labels = {
        app = "pod-manager"
      }
    }

    template {
      metadata {
        labels = {
          app = "pod-manager"
          tier = "ai"
        }
      }

      spec {
        service_account_name = "pod-manager"

        container {
          name  = "pod-manager"
          image = "${var.image_repository}:${var.image_tag}"

          port {
            container_port = 8080
            name           = "http"
          }

          env_from {
            config_map_ref {
              name = "headlamp-ai-config"
            }
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = 8080
            }
            initial_delay_seconds = 5
            period_seconds        = 5
          }

          liveness_probe {
            http_get {
              path = "/health"
              port = 8080
            }
            initial_delay_seconds = 30
            period_seconds        = 10
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
          }

          security_context {
            read_only_root_filesystem   = true
            allow_privilege_escalation = false

            capabilities {
              drop = ["ALL"]
            }
          }
        }
      }
    }
  }

  depends_on = [kubernetes_service_account.pod_manager]
}

# Service
resource "kubernetes_service" "pod_manager" {
  metadata {
    name      = "pod-manager"
    namespace = var.namespace
  }

  spec {
    type = "ClusterIP"

    port {
      port        = 8080
      target_port = 8080
      protocol    = "TCP"
      name        = "http"
    }

    selector = {
      app = "pod-manager"
    }
  }

  depends_on = [kubernetes_deployment.pod_manager]
}

# Network Policy
resource "kubernetes_network_policy" "pod_manager" {
  metadata {
    name      = "pod-manager"
    namespace = var.namespace
  }

  spec {
    pod_selector {
      match_labels = {
        app = "pod-manager"
      }
    }

    policy_types = ["Ingress", "Egress"]

    ingress {
      from {
        namespace_selector {
          match_labels = {
            "app.kubernetes.io/metadata.name" = "headlamp"
          }
        }
      }
    }

    egress {
      to {
        namespace_selector {}
      }
      ports {
        protocol = "TCP"
        port     = 443
      }
      ports {
        protocol = "TCP"
        port     = 80
      }
    }
  }

  depends_on = [kubernetes_deployment.pod_manager]
}