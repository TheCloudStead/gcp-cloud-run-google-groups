resource "google_firestore_database" "database" {
  project     = var.project_name
  name        = "(default)"
  location_id = "nam5"
  type        = "FIRESTORE_NATIVE"
}