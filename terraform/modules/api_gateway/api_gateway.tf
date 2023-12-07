resource "aws_api_gateway_rest_api" "tm_api" {
  name        = "tenant-management-api"
  description = "Tenant Management REST API"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
} # aws_api_gateway_rest_api.tm_api

module "echo_resource" {
  source               = "./api_resource"
  api_gateway_id       = aws_api_gateway_rest_api.tm_api.id
  api_root_resource_id = aws_api_gateway_rest_api.tm_api.root_resource_id
  api_config = {
    http_method = "POST"
    path        = "echo"
  }

  depends_on = [
    aws_api_gateway_rest_api.tm_api
  ]
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.tm_api.id
  stage_name  = "v1"

  depends_on = [
    module.echo_resource
  ]
}
