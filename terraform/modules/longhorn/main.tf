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
  version    = "1.9.1" #https://github.com/longhorn/longhorn/releases

  wait = true
  
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

  set {
    name  = "defaultSettings.backupTarget"
    value = "s3://${var.bucket_name}@us/backups/"
  }
  
  set {
    name  = "defaultSettings.backupTargetCredentialSecret"
    value = "gcp-backup-secret"
  }
}