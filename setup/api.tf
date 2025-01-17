resource "google_project_service" "cloud_resourcemanager_api" {
  project            = var.project_name
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "artifact_registry_api" {
  project            = var.project_name
  service            = "artifactregistry.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "cloud_run_api" {
  project            = var.project_name
  service            = "run.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "cloud_scheduler_api" {
  project            = var.project_name
  service            = "cloudscheduler.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "admin_api" {
  project            = var.project_name
  service            = "admin.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "secret_manager_api" {
  project            = var.project_name
  service            = "secretmanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "firestore_api" {
  project            = var.project_name
  service            = "firestore.googleapis.com"
  disable_on_destroy = false
}