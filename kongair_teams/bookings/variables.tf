#Variables
variable "control_plane_id" {
  type = string
  default = "" # Enter CP ID provided by Platform Team here
}

variable "portal_id" {
    type = string
    default = "" # Enter Portal ID provided by the Platform team
}


variable "PLATFORM_SPAT" {
  description = "System Access Token for Kong Konnect"
  type        = string
}