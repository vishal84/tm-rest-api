resource "aws_api_gateway_resource" "resource" {
  rest_api_id = var.api_gateway_id
  parent_id   = var.api_root_resource_id
  path_part   = var.api_config.path
} # aws_api_gateway_resource.resource

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = var.api_gateway_id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = var.api_config.http_method
  authorization = "NONE"
} # aws_api_gateway_method.proxy

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = var.api_gateway_id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = var.api_config.http_method
  integration_http_method = aws_api_gateway_method.proxy.http_method
  type                    = "MOCK"
} # aws_api_gateway_integration.lambda_integration

resource "aws_api_gateway_integration_response" "proxy" {
  rest_api_id = var.api_gateway_id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = "POST"
  status_code = aws_api_gateway_method_response.proxy.status_code

  depends_on = [
    aws_api_gateway_method.proxy,
    aws_api_gateway_integration.lambda_integration
  ]
} # aws_api_gateway_integration_response.proxy

resource "aws_api_gateway_method_response" "proxy" {
  rest_api_id = var.api_gateway_id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.proxy.http_method
  status_code = "200"
} # aws_api_gateway_method_response.proxy
