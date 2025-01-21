#Variables
# API Product configuration 
resource "konnect_api_product" "$PRODUCT" { 
  name        = "$PRODUCT Product" 
  description = "This product productizes the $PRODUCT service"

  portal_ids = [
    var.portal_id
  ]
}

resource "konnect_api_product_version" "${PRODUCT}_v1" { 
  api_product_id = konnect_api_product.$PRODUCT.id
  name           = "v1"
  gateway_service = {
    control_plane_id = var.control_plane_id
    id               = konnect_gateway_service.${PRODUCT}_service.id
  }
}

resource "konnect_api_product_specification" "${PRODUCT}_v1_spec" { 
  name                   = "$PRODUCT.yaml"
  content                = base64encode(file("./openapi.yaml"))
  api_product_id         = konnect_api_product.$PRODUCT.id 
  api_product_version_id = konnect_api_product_version.${PRODUCT}_v1.id
}

# Define an authentication strategy to be used by the product version
resource "konnect_application_auth_strategy" "${PRODUCT}_authstrategy" {
  key_auth = {
    name          = "${PRODUCT}-auth-strategy"
    key_names     = ["apikey"]
    display_name  = "${PRODUCT} Auth Strategy"
    strategy_type = "key_auth"
    configs = {
      key_auth = {
        key_names = ["apikey"]
      }
    }
  }
}

# Assign the product version to a portal
resource "konnect_portal_product_version" "${PRODUCT}_v1" {
  application_registration_enabled = true
  auto_approve_registration        = false
  deprecated                       = false
  publish_status                   = "published"

  portal_id          = var.portal_id
  product_version_id = konnect_api_product_version.${PRODUCT}_v1.id 
  auth_strategy_ids = [
    konnect_application_auth_strategy.${PRODUCT}_authstrategy.id
  ]
}