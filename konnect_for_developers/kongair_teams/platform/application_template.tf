# Control Plane configuration

# This lab uses a serverless control plane. If you are unable to use a serverless gateway, uncomment the following section to create your control plane.

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


# Portal Configuration
resource "konnect_portal" "kongairportal" {
  name                      = "Kong Air Portal"
  auto_approve_applications = false
  auto_approve_developers   = true
  is_public                 = false
  rbac_enabled              = false
}

# Team Configuration

# We create a team specifically for the Kong Air Developers. This team will have the Deployer role on the control plane.
resource "konnect_team" "kongair_developers" {
  description = "Allow managing the control plane service, route and plugin configuration"
  name        = "Kong Air Developers"
}

resource "konnect_team_role" "kongair_deployer_role" {
  entity_id        = var.control_plane_id
  entity_region    = "us"
  entity_type_name = "Control Planes"
  role_name        = "Deployer"
  team_id          = konnect_team.kongair_developers.id
}

resource "konnect_team_role" "kongair_service_admin_role" {
  entity_id        = "*"
  entity_region    = "us"
  entity_type_name = "Control Planes"
  role_name        = "Gateway Service Admin"
  team_id          = konnect_team.kongair_developers.id
}

resource "konnect_team_role" "kongair_plugins_admin_role" {
  entity_id        = "*"
  entity_region    = "us"
  entity_type_name = "Control Planes"
  role_name        = "Plugin Admin"
  team_id          = konnect_team.kongair_developers.id
}

resource "konnect_team_role" "kongair_route_admin_role" {
  entity_id        = "*"
  entity_region    = "us"
  entity_type_name = "Control Planes"
  role_name        = "Route Admin"
  team_id          = konnect_team.kongair_developers.id
}
resource "konnect_team_role" "kongair_upstream_admin_role" {
  entity_id        = "*"
  entity_region    = "us"
  entity_type_name = "Control Planes"
  role_name        = "Upstream Admin"
  team_id          = konnect_team.kongair_developers.id
}

resource "konnect_team_role" "kongair_products_creator_role" {
  entity_id        = "*"
  entity_region    = "us"
  entity_type_name = "API Products"
  role_name        = "Creator"
  team_id          = konnect_team.kongair_developers.id
}

resource "konnect_team_role" "kongair_products_maintainer_role" {
  entity_id        = "*"
  entity_region    = "us"
  entity_type_name = "API Products"
  role_name        = "Maintainer"
  team_id          = konnect_team.kongair_developers.id
}

resource "konnect_team_role" "kongair_products_publisher_role" {
  entity_id        = "*"
  entity_region    = "us"
  entity_type_name = "API Products"
  role_name        = "Publisher"
  team_id          = konnect_team.kongair_developers.id
}

resource "konnect_team_role" "kongair_portal_admin_role" {
  entity_id        = konnect_portal.kongairportal.id
  entity_region    = "us"
  entity_type_name = "Portals"
  role_name        = "Admin"
  team_id          = konnect_team.kongair_developers.id
}

resource "konnect_team_role" "kongair_auth_strategies_role" {
  entity_id        = "*"
  entity_region    = "us"
  entity_type_name = "Application Auth Strategies"
  role_name        = "Creator"
  team_id          = konnect_team.kongair_developers.id
}

# System Account Configuration

resource "konnect_system_account" "kongair_developer_sa" {
  name            = "kongair_developer_sa"
  description     = "System account for KongAir Developers"
  konnect_managed = false

}

resource "konnect_system_account_team" "kongair_developers" {
  account_id = konnect_system_account.kongair_developer_sa.id
  team_id = konnect_team.kongair_developers.id
}

resource "konnect_system_account_access_token" "kongair_developers_platform_token" {

  name       = "kongair_developers_platform_token"
  expires_at = var.token_expiration_date
  account_id = konnect_system_account.kongair_developer_sa.id

}

# Configure CORS plugin
# This is used to ensure that the learners can use the "Try it out" functionality in the portal.
resource "konnect_gateway_plugin_cors" "cors_plugin" {
  enabled = true

  config = {
    origins = ["*"]
    methods = ["GET", "POST","PUT", "PATCH", "DELETE", "OPTIONS"]
    headers = ["Accept", "Accept-Version", "Content-Length", "Content-MD5", "Content-Type", "Date", "X-Auth-Token", "apiKey", "apikey","x-consumer-username"]
    exposed_headers = ["X-Auth-Token", "apiKey","x-consumer-username"]
    credentials = true
    max_age = 3600
  }

  control_plane_id = var.control_plane_id
}

output "developer_sa_token" {
    value = konnect_system_account_access_token.kongair_developers_platform_token.token
}

output "control_plane_id" {
    value = var.control_plane_id
}

output "portal_id" {
    value = konnect_portal.kongairportal.id
}

output "portal_url" {
    value = konnect_portal.kongairportal.default_domain
}