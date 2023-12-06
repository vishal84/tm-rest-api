# Create a Cognito pool for Saas Ops users (Admin, Support, etc)
data "aws_caller_identity" "current" {}

resource "aws_cognito_user_pool" "operations_user_pool" {
  name = "operations-users"

  auto_verified_attributes = ["email"]
  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  admin_create_user_config {
    invite_message_template {
      email_subject = "Welcome! A new operations user has been created."
      email_message = templatefile("${path.module}/templates/operations_user_signup.tftpl", {

      })
      # sms_message = "Your username is {username} and password is {####}."
    }
  }

  schema {
    attribute_data_type = "String"
    name                = "email"
    required            = true
    mutable             = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  schema {
    attribute_data_type = "String"
    name                = "role"
    required            = false
    mutable             = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  schema {
    attribute_data_type = "String"
    name                = "tenantId"
    mutable             = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  schema {
    attribute_data_type = "String"
    name                = "apiKey"
    required            = false
    mutable             = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }
} # aws_cognito_user_pool.operations_user_pool

resource "aws_cognito_user_pool_client" "operations_client" {
  name                                 = "operations-client"
  allowed_oauth_flows_user_pool_client = true
  generate_secret                      = false
  allowed_oauth_scopes                 = ["aws.cognito.signin.user.admin", "email", "openid", "profile"]
  allowed_oauth_flows                  = ["implicit", "code"]
  explicit_auth_flows                  = ["ADMIN_NO_SRP_AUTH", "USER_PASSWORD_AUTH"]
  supported_identity_providers         = ["COGNITO"]
  prevent_user_existence_errors        = "ENABLED"

  write_attributes = ["email", "custom:tenantId", "custom:role", "custom:apiKey"]

  user_pool_id  = aws_cognito_user_pool.operations_user_pool.id
  callback_urls = ["https://example.com"]
  logout_urls   = ["https://example.com"]
} # aws_cognito_user_pool_client.operations_client

resource "aws_cognito_user_pool_ui_customization" "operations_user_pool_ui_customization" {
  client_id  = aws_cognito_user_pool_client.operations_client.id
  css        = ".banner-customizable { background-color: #5A4570; }"
  image_file = filebase64("${path.module}/images/rocket1.png")

  user_pool_id = aws_cognito_user_pool.operations_user_pool.id
}

resource "aws_cognito_user" "admin" {
  user_pool_id = aws_cognito_user_pool.operations_user_pool.id
  username     = "admin"
  password     = "@dmin123!"

  desired_delivery_mediums = ["EMAIL"]
  force_alias_creation     = true

  attributes = {
    email      = "admin@example.com"
    "tenantId" = "admin"
    "apiKey"   = "adminKey123"
    "role"     = "admin"
  }
} # aws_cognito_user.admin

resource "aws_cognito_user_group" "admin_group" {
  name         = "admins"
  description  = "A user group for operations administrators."
  user_pool_id = aws_cognito_user_pool.operations_user_pool.id
  precedence   = 0
} # aws_cognito_user_group.admin_group

resource "aws_cognito_user_in_group" "add_admin_to_admin_group" {
  user_pool_id = aws_cognito_user_pool.operations_user_pool.id
  group_name   = aws_cognito_user_group.admin_group.name
  username     = aws_cognito_user.admin.username
} # aws_cognito_user_in_group.add_admin_to_admin_group
