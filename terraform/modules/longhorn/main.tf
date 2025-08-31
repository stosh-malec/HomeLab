resource "kubernetes_namespace" "longhorn_system" {
  metadata {
    name = "longhorn-system"
  }
}

resource "helm_release" "longhorn" {
  name       = "longhorn"
  namespace  = kubernetes_namespace.longhorn_system.metadata[0].name
  repository = "https://charts.longhorn.io"
  chart      = "longhorn"
  version    = "1.9.1" # Specify the desired version

  # Wait for the deployment to complete
  wait = true
  
  # Values configuration
  values = [
    file("${path.module}/values.yaml")
  ]
  
  set {
    name  = "persistence.defaultClass"
    value = "true"
  }
  
  set {
    name  = "persistence.defaultClassReplicaCount"
    value = "2"
  }

  # Create service account for GCP backup access
  set {
    name  = "defaultSettings.backupTarget"
    value = "s3://${var.bucket_name}@${var.region}/backups/"
  }
  
  set {
    name  = "defaultSettings.backupTargetCredentialSecret"
    value = "gcp-backup-secret"
  }
}
