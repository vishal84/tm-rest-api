variable "api_gateway_id" {
  type        = string
  description = "The ID of the associated REST API"
}

variable "api_root_resource_id" {
  type        = string
  description = "The ID of the root resource of the REST API"
}

variable "api_config" {
  type = object({
    http_method = string
    path        = string
  })
  description = "Configuration metadata for the API resource"
}
