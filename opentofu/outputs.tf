output "client_id" {
  value = google_service_account.service_account.unique_id
}

output "oauth_scopes" {
  value = var.scopes
}