resource "kubernetes_secret" "gcp_backup_secret" {
  metadata {
    name      = "gcp-backup-secret"
    namespace = kubernetes_namespace.longhorn_system.metadata[0].name
    annotations = {
      "longhorn.io/backup-target" = "s3://${var.bucket_name}@us/backups/"
    }
  }

  data = {
    AWS_ACCESS_KEY_ID     = var.gcp_access_key_id
    AWS_SECRET_ACCESS_KEY = var.gcp_secret_access_key
    AWS_ENDPOINTS         = "https://storage.googleapis.com"
  }

  depends_on = [kubernetes_namespace.longhorn_system]
}
