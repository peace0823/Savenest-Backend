# =================================================================
#  SIGNUP  ROLE
# =================================================================
output "SIGN_UP_FUNCTION_ROLE_ARN" {
  value = aws_iam_role.sign_up_function_role.arn
}
output "SIGN_UP_FUNCTION_ROLE_NAME" {
  value = aws_iam_role.sign_up_function_role.name
}

# =================================================================
#  CONFIRM SIGNUP  ROLE
# =================================================================
output "CONFIRM_SIGN_UP_FUNCTION_ROLE_ARN" {
  value = aws_iam_role.confirm_sign_up_function_role.arn
}
output "CONFIRM_SIGN_UP_FUNCTION_ROLE_NAME" {
  value = aws_iam_role.confirm_sign_up_function_role.name
}

# =================================================================
#  LOGIN  ROLE
# =================================================================
output "LOGIN_FUNCTION_ROLE_ARN" {
  value = aws_iam_role.login_function_role.arn
}
output "LOGIN_FUNCTION_ROLE_NAME" {
  value = aws_iam_role.login_function_role.name
}

# =================================================================
#  FORGOT PASSWORD
# =================================================================
output "FORGOT_PASSWORD_FUNCTION_ROLE_ARN" {
  value = aws_iam_role.forgot_password_function_role.arn
}
output "FORGOT_PASSWORD_FUNCTION_ROLE_NAME" {
  value = aws_iam_role.forgot_password_function_role.name
}

# =================================================================
#  CONFIRM FORGOT PASSWORD
# =================================================================
output "CONFIRM_FORGOT_PASSWORD_FUNCTION_ROLE_ARN" {
  value = aws_iam_role.confirm_forgot_password_function_role.arn
}
output "CONFIRM_FORGOT_PASSWORD_FUNCTION_ROLE_NAME" {
  value = aws_iam_role.confirm_forgot_password_function_role.name
}