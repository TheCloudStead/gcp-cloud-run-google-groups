project_id                       = ""
project_name                     = ""
region                           = "us-central1"
location                         = "US"
timezone                         = "America/Chicago"
frequency                        = "0 */12 * * *"
timeout                          = "900s"
memory                           = "2048Mi"
cpu                              = "2000m"
cloud_run_container_path         = "gcr.io/<project_id>/get-google-groups"
cloud_run_container_path_version = "1.0"
secret_id                        = "get-google-groups-key"
domain                           = ""
delegated_admin                  = ""
scopes = [
  "https://www.googleapis.com/auth/admin.directory.group.readonly",
  "https://www.googleapis.com/auth/admin.directory.group.member.readonly"
]
collection = "google-groups"