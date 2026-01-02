resource "kubernetes_namespace" "velero" {
  metadata {
    name = "velero"
  }
}

resource "kubernetes_secret" "velero_gcp_secret" {
  metadata {
    name      = "cloud-credentials"
    namespace = kubernetes_namespace.velero.metadata[0].name
  }

  data = {
    "cloud" = var.gcp_service_account_key
  }
}

resource "helm_release" "velero" {
  name       = "velero"
  repository = "https://vmware-tanzu.github.io/helm-charts"
  chart      = "velero"
  namespace  = kubernetes_namespace.velero.metadata[0].name
  version    = var.velero_chart_version

  # Skip CRD upgrade hooks - they fail on ARM64 and CRDs are already installed
  disable_webhooks = true

  values = [
    templatefile("${path.module}/values.yaml", {
      bucket_name              = var.bucket_name
      gcp_project_id          = var.gcp_project_id
      velero_gcp_plugin_version = var.velero_gcp_plugin_version
    })
  ]

  depends_on = [kubernetes_secret.velero_gcp_secret]
}
