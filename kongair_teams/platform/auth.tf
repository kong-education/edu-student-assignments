# Configure the provider to use your Kong Konnect account
terraform {
  required_providers {
    konnect = {
      source  = "kong/konnect"
      version = "2.2.0"
    }
  }
}

provider "konnect" {
  personal_access_token = "ENTER KPAT TOKEN HERE"
  server_url            = "https://us.api.konghq.com"
}
