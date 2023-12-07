module "operations_users" {
  source = "./modules/cognito"
}

module "tenant_management_api" {
  source = "./modules/api_gateway"
}
