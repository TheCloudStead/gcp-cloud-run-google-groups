#######################################################
# service account
#######################################################

resource "google_service_account" "service_account" {
  account_id   = local.purpose
  display_name = "${local.purpose_fmt} Service Account"
}

resource "google_project_iam_member" "secret_accessor_role" {
  project = var.project_name
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_project_iam_member" "firestore_role" {
  project = var.project_name
  role    = "roles/datastore.user"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_service_account" "trigger_service_account" {
  account_id   = "${local.purpose}-trig"
  display_name = "${local.purpose_fmt} Trigger Service Account"
}

resource "google_project_iam_member" "invoker_role" {
  project = var.project_name
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.trigger_service_account.email}"
}

#######################################################
# service account key secret
#######################################################

resource "google_service_account_key" "service_account_key" {
  service_account_id = google_service_account.service_account.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "google_secret_manager_secret" "sa_key_secret" {
  secret_id = "${local.purpose}-key"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "sa_key_secret_version" {
  secret      = google_secret_manager_secret.sa_key_secret.id
  secret_data = base64decode(google_service_account_key.service_account_key.private_key)
}

#######################################################
#######################################################