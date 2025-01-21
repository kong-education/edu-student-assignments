# Create a new Control Plane
# resource "konnect_gateway_control_plane" "kongair" {
#   name         = "Control Plane for the Kong Air Team"
#   description  = "Aggregated Control Plane for Kong Air Application"
#   cluster_type = "CLUSTER_TYPE_CONTROL_PLANE"
#   auth_type    = "pinned_client_certs"

#   proxy_urls = [
#     {
#       host     = "example.com",
#       port     = 443,
#       protocol = "https"
#     }
#   ]
# }

# Configure CORS plugin
# This is used to ensure that the learners can use the "Try it out" functionality in the portal.

resource "konnect_gateway_plugin_cors" "cors_plugin" {
  enabled = true

  config = {
    origins = ["*"]
    methods = ["GET", "POST", "OPTIONS"]
    headers = ["Accept", "Accept-Version", "Content-Length", "Content-MD5", "Content-Type", "Date", "X-Auth-Token"]
    exposed_headers = ["X-Auth-Token"]
    credentials = true
    max_age = 3600
  }

  control_plane_id = var.control_plane_id
}

# resource "konnect_gateway_plugin_rate_limiting_advanced" "org_wide_rate_limiting" {
#   enabled = true

#   config = {
#     limit = [5000]
#     window_size = [3600]
#     identifier = "consumer"
#     sync_rate = -1
#     namespace = "example_namespace"
#     strategy = "local"
#     hide_client_headers = false
#   }

#   control_plane_id = konnect_gateway_control_plane.my_konnect_cp.id
# }

# Portal Configuration
resource "konnect_portal" "kongairportal" {
  name                      = "Kong Air Portal"
  auto_approve_applications = false
  auto_approve_developers   = true
  is_public                 = false
  rbac_enabled              = false
}

# # Control Plane Output (Please provide to application teams)
# output "control_plane_id" {
#   value = konnect_gateway_control_plane.kongair.id
# }

# Portal ID Output (Please provide to application team)
output "portal_id" {
    value = konnect_portal.kongairportal.id
}