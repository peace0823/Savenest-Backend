output "COGNITO_USER_POOL_ARN" {
  description = "ARN of the Cognito User Pool"
  value       = aws_cognito_user_pool.cognito_end_user_userpool.arn
}

output "COGNITO_USER_POOL_ID" {
  description = "ID of the Cognito User Pool"
  value       = aws_cognito_user_pool.cognito_end_user_userpool.id
}

output "COGNITO_USER_CLIENT_SECRET_A" {
  description = "Client secret for the Cognito User Pool Client"
  value       = aws_cognito_user_pool_client.cognito_client_end_user.client_secret
}

output "COGNITO_USER_CLIENT_ID_A" {
  description = "Client ID for the Cognito User Pool Client"
  value       = aws_cognito_user_pool_client.cognito_client_end_user.id
}

# output "COGNITO_USER_CLIENT_SECRET_O"{
#   value = "${aws_cognito_user_pool_client.cognito_client_operators.client_secret}"
# }

# output "COGNITO_USER_CLIENT_SECRET_R"{
#   value = "${aws_cognito_user_pool_client.cognito_client_regulators.client_secret}"
# }

# output "COGNITO_USER_CLIENT_ID_O"{
#   value = "${aws_cognito_user_pool_client.cognito_client_operators.id}"
# }

# output "COGNITO_USER_CLIENT_ID_R"{
#   value = "${aws_cognito_user_pool_client.cognito_client_regulators.id}"
# }
