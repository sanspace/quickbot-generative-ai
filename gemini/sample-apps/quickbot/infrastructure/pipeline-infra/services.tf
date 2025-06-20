module "project-services" {
  # https://github.com/terraform-google-modules/terraform-google-project-factory/tree/main/modules/project_services
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 18.0"

  project_id    = var.project_id
  activate_apis = var.activate_apis

  disable_services_on_destroy = false
  disable_dependent_services  = false
}
