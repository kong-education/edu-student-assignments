#Variables
variable "control_plane_id" {
  type = string
  default = "d5d19f00-21b6-4b39-bb26-61d5038514d6" 
}

variable "PLATFORM_KPAT" {
  description = "Personal Access Token for Kong Konnect"
  type        = string
}
