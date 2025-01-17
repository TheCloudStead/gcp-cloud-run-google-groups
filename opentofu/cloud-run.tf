######################################################
# cloud run job
######################################################

resource "google_cloud_run_v2_job" "cloudrun_job" {
  name                = "${local.purpose}-cloudrun-job"
  location            = var.region
  deletion_protection = false

  template {
    task_count = 1
    template {
      timeout         = var.timeout
      max_retries     = 0
      service_account = google_service_account.service_account.email
      containers {
        image = "${var.cloud_run_container_path}:${var.cloud_run_container_path_version}"
        resources {
          limits = {
            memory = var.memory
            cpu    = var.cpu
          }
        }
        ports {}
        env {
          name  = "PROJECT_ID"
          value = var.project_id

        }
        env {
          name  = "SECRET_ID"
          value = var.secret_id
        }
        env {
          name  = "DOMAIN"
          value = var.domain
        }
        env {
          name  = "DELEGATED_ADMIN"
          value = var.delegated_admin
        }
        env {
          name  = "SCOPES"
          value = join(",", var.scopes)
        }
        env {
          name  = "COLLECTION"
          value = var.collection
        }

      }
    }
  }
}

######################################################
# cloud run job trigger
######################################################

resource "google_cloud_scheduler_job" "cloudrun_scheduler" {
  name      = "${local.purpose}-cloudrun-trigger"
  schedule  = var.frequency
  time_zone = var.timezone

  http_target {
    http_method = "POST"
    uri         = "https://${google_cloud_run_v2_job.cloudrun_job.location}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${var.project_id}/jobs/${google_cloud_run_v2_job.cloudrun_job.name}:run"

    oauth_token {
      scope                 = "https://www.googleapis.com/auth/cloud-platform"
      service_account_email = google_service_account.trigger_service_account.email
    }
  }
}

######################################################
######################################################