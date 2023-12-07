module "operations_users" {
  source = "./modules/cognito"
}

module "api_lambda_integrations" {
  source = "./modules/lambda"
}

module "tenant_management_api" {
  source = "./modules/api_gateway"
}
