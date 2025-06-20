variable "project_id" {
  type        = string
  description = "The project ID to deploy the resources in."
}

variable "activate_apis" {
  description = "A list of APIs to enable."
  type        = list(string)
  default     = []
}

variable "region" {
  type        = string
  description = "The region for the resources."
  default     = "us-central1"
}

variable "github_repo_owner" {
  type        = string
  description = "The owner of the GitHub repository (e.g., your username)."
}

variable "github_repo_name" {
  type        = string
  description = "The name of the GitHub repository."
}

variable "branch_name" {
  type        = string
  description = "The name of the branch that will trigger builds (e.g., main)."
}

variable "ar_repo_name" {
  type        = string
  description = "The name for the Artifact Registry Docker repository."
  default     = "quickbot-apps"
}

variable "cloudbuild_service_account_id" {
  type        = string
  description = "The ID for the service account Cloud Build will use."
  default     = "quickbot-builder-sa"
}
