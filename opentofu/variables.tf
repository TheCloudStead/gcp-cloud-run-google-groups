variable "project_id" {
  type        = string
  description = "Project ID"
}

variable "project_name" {
  type        = string
  description = "Project Name"
}

variable "region" {
  type        = string
  description = "Region for resources"
}

variable "location" {
  type        = string
  description = "Location for resources"
}

variable "timezone" {
  type        = string
  description = "Frequency to run cloud run automation"
}

variable "frequency" {
  type        = string
  description = "Frequency to run cloud run automation"
}

variable "timeout" {
  type        = string
  description = "Timeout for cloud run job"
}

variable "memory" {
  type        = string
  description = "Memory for cloud run job"
}

variable "cpu" {
  type        = string
  description = "CPU for cloud run job"
}

variable "cloud_run_container_path" {
  type        = string
  description = "GCR path for container"
}

variable "cloud_run_container_path_version" {
  type        = string
  description = "GCR version path for container"
}

variable "secret_id" {
  type        = string
  description = "Secret Name"
}

variable "domain" {
  type        = string
  description = "Domain"
}

variable "delegated_admin" {
  type        = string
  description = "Email of Delegated Admin"
}

variable "scopes" {
  type        = list(any)
  description = "List of OAUTH scopes"
}

variable "collection" {
  type        = string
  description = "Collection Name"
}