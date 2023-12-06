# Create a Cognito pool for Saas Ops users (Admin, Support, etc)
resource "aws_cognito_user_pool" "operations_user_pool" {
  name = "operations"
}

