terraform {
  required_version = ">= 1.0"
  
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
    argocd = {
      source  = "oboukili/argocd"
      version = "~> 6.0"
    }
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig_path
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
  }
}

provider "argocd" {
  username = var.argocd_username
  password = var.argocd_password
  server   = var.argocd_server
}

variable "kubeconfig_path" {
  description = "Path to kubeconfig file"
  type        = string
  default     = "~/.kube/config"
}

variable "argocd_server" {
  description = "ArgoCD server URL"
  type        = string
  default     = "http://localhost:8080"
}

variable "argocd_username" {
  description = "ArgoCD username"
  type        = string
  default     = "admin"
}

variable "argocd_password" {
  description = "ArgoCD password"
  type        = string
  sensitive   = true
}

variable "namespace" {
  description = "Target namespace for resources"
  type        = string
  default     = "headlamp"
}

variable "replica_count" {
  description = "Number of pod-manager replicas"
  type        = number
  default     = 2
}

variable "ai_provider" {
  description = "AI provider to use"
  type        = string
  default     = "openai"
  validation {
    condition     = contains(["openai", "azure", "anthropic", "deepseek", "ollama"], var.ai_provider)
    error_message = "Provider must be one of: openai, azure, anthropic, deepseek, ollama."
  }
}

variable "enable_mcp" {
  description = "Enable MCP servers"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}