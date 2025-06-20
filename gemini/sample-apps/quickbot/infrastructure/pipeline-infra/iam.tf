# infrastructure/pipeline-infra/iam.tf

# Create the dedicated service account that Cloud Build will use.
resource "google_service_account" "cloudbuild_sa" {
  account_id   = var.cloudbuild_service_account_id
  display_name = "QuickBot CI/CD Builder Service Account"
  description  = "Service account used by the QuickBot dispatcher build. Managed by Terraform."
}

# Grant the new service account permission to push to Artifact Registry.
resource "google_project_iam_member" "build_sa_artifact_registry_writer" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.cloudbuild_sa.email}"
}

# Grant it permission to deploy to Cloud Run.
resource "google_project_iam_member" "build_sa_cloud_run_admin" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.cloudbuild_sa.email}"
}

# Grant it the Service Account User role so it can act as the Cloud Run runtime service account.
resource "google_project_iam_member" "build_sa_service_account_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.cloudbuild_sa.email}"
}

# Grant it the Cloud Build Editor role so the dispatcher build can submit other builds.
resource "google_project_iam_member" "build_sa_editor" {
  project = var.project_id
  role    = "roles/cloudbuild.builds.editor"
  member  = "serviceAccount:${google_service_account.cloudbuild_sa.email}"
}

# Grant it the Logs Writer role so it can write logs to Cloud Logging.
resource "google_project_iam_member" "build_log_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.cloudbuild_sa.email}"
}

# --- Permissions for the Terraform SA (tf-deployer-sa) ---
# The following blocks are necessary for the account running `terraform apply`.

# Add this data source to dynamically get the identity of the caller (tf-deployer-sa).
data "google_client_openid_userinfo" "current" {}

# Grant the Terraform SA (tf-deployer-sa) the ability to "act as" the Cloud Build SA.
# This is REQUIRED by the Cloud Build API when creating a trigger with a custom service account.
# This directly solves the "user does not have impersonation permission" error.
resource "google_service_account_iam_member" "terraform_sa_can_impersonate_build_sa" {
  service_account_id = google_service_account.cloudbuild_sa.name
  role               = "roles/iam.serviceAccountUser"
  # This dynamically uses the email of the user/service account running terraform.
  # When impersonating, this will be the email of the service account.
  member = "serviceAccount:${data.google_client_openid_userinfo.current.email}"
}
