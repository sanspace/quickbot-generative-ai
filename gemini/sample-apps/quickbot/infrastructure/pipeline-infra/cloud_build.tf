# infrastructure/pipeline-infra/cloud_build.tf

resource "google_cloudbuild_trigger" "dispatcher_trigger" {
  project     = var.project_id
  name        = "trigger-quickbot-dispatcher"
  description = "Dispatches builds for any changed application within the quickbot folder. Managed by Terraform."
  location    = var.region

  # Tell the trigger to impersonate the new service account we created.
  service_account = google_service_account.cloudbuild_sa.id

  github {
    owner = var.github_repo_owner
    name  = var.github_repo_name
    push {
      branch = "^${var.branch_name}$"
    }
  }

  filename       = "gemini/sample-apps/quickbot/infrastructure/cloudbuild.yaml"
  included_files = ["gemini/sample-apps/quickbot/**"]

  substitutions = {
    _GCP_REGION   = var.region
    _AR_REPO_NAME = var.ar_repo_name
  }

  depends_on = [
    google_project_iam_member.build_sa_cloud_run_admin,
    google_project_iam_member.build_sa_artifact_registry_writer,
    google_project_iam_member.build_sa_service_account_user,
    google_project_iam_member.build_sa_editor,
    google_project_iam_member.build_log_writer,
  ]
}
