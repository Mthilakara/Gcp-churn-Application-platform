# 1. Artifact Registry for your Dockerized App
resource "google_artifact_registry_repository" "app_repo" {
  location      = var.region
  repository_id = "churn-app-repo"
  description   = "Repository for the Churn Application Docker image"
  format        = "DOCKER"
}

# 2. Application Service Account (The "Identity" of your app)
resource "google_service_account" "app_sa" {
  account_id   = "churn-app-service-account"
  display_name = "Service Account for Churn Application"
}

# 3. Permissions for the Application
# Role to query BigQuery tables
resource "google_project_iam_member" "app_bq_reader" {
  project = var.project_id
  role    = "roles/bigquery.jobUser"
  member  = "service_account:${google_service_account.app_sa.email}"
}

resource "google_project_iam_member" "app_bq_data_viewer" {
  project = var.project_id
  role    = "roles/bigquery.dataViewer"
  member  = "service_account:${google_service_account.app_sa.email}"
}

# Role to call the Vertex AI Model for prediction
resource "google_project_iam_member" "app_vertex_user" {
  project = var.project_id
  role    = "roles/aiplatform.user"
  member  = "service_account:${google_service_account.app_sa.email}"
}