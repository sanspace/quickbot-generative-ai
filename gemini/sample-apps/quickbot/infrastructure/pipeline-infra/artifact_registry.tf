# infrastructure/pipeline-infra/artifact_registry.tf

resource "google_artifact_registry_repository" "main" {
  project       = var.project_id
  location      = var.region
  repository_id = var.ar_repo_name
  description   = "Docker repository for QuickBot applications, managed by Terraform."
  format        = "DOCKER"
}
