data "archive_file" "echo_package" {
  type        = "zip"
  source_file = "${path.module}/handlers/echo.js"
  output_path = "index.zip"
}

resource "aws_lambda_function" "echo_fn" {
  filename         = "index.zip"
  function_name    = "echo_fn"
  role             = aws_iam_role.echo_role.arn
  handler          = "index.handler"
  runtime          = "nodejs16.x"
  source_code_hash = data.archive_file.echo_package.output_base64sha256
}

resource "aws_iam_role" "echo_role" {
  name = "echo-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}
