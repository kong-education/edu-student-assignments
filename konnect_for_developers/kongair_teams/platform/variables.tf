#Variables
variable "control_plane_id" {
  type = string
  default = "ab41f304-baab-41c6-b0cf-dbaf59add525" 
}

variable "PLATFORM_KPAT" {
  description = "Personal Access Token for Kong Konnect"
  type        = string
}

variable "token_expiration_date" {
  type    = string
  default = "2025-05-30T17:00:00Z" # Placeholder, updated via token_data.tfvars
}