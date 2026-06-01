# Terraform outputs for Headlamp AI Stack

output "namespace" {
  description = "Target namespace"
  value       = var.namespace
}

output "argocd_app_name" {
  description = "ArgoCD application name"
  value       = argocd_application.headlamp_ai.metadata[0].name
}

output "argocd_app_url" {
  description = "ArgoCD application URL"
  value       = "https://${var.argocd_server}/applications/${argocd_application.headlamp_ai.metadata[0].name}"
}

output "pod_manager_service" {
  description = "Pod Manager service endpoint"
  value       = kubernetes_service.pod_manager.metadata[0].name
}

output "pod_manager_deployment" {
  description = "Pod Manager deployment name"
  value       = kubernetes_deployment.pod_manager.metadata[0].name
}

output "replica_count" {
  description = "Number of pod manager replicas"
  value       = kubernetes_deployment.pod_manager.spec[0].replicas
}

output "service_endpoint" {
  description = "Cluster-internal service endpoint"
  value       = "${kubernetes_service.pod_manager.metadata[0].name}.${var.namespace}.svc:${kubernetes_service.pod_manager.spec[0].port[0].port}"
}

output "ai_config" {
  description = "AI configuration"
  value       = kubernetes_config_map.ai_config.data
}

output "all_resources" {
  description = "All deployed resources"
  value = {
    namespace         = var.namespace
    service_account   = kubernetes_service_account.pod_manager.metadata[0].name
    role              = kubernetes_role.pod_manager.metadata[0].name
    deployment        = kubernetes_deployment.pod_manager.metadata[0].name
    service           = kubernetes_service.pod_manager.metadata[0].name
    network_policy    = kubernetes_network_policy.pod_manager.metadata[0].name
    config_map        = kubernetes_config_map.ai_config.metadata[0].name
    argocd_application = argocd_application.headlamp_ai.metadata[0].name
  }
}