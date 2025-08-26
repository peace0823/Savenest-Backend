# =================================================================
#  SIGNUP ROLE
# =================================================================
resource "aws_iam_role" "sign_up_function_role" {
  name = "SIGN_UP_FUNCTION_${var.RESOURCES_PREFIX}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# =================================================================
#  CONFIRM SIGNUP ROLE
# =================================================================
resource "aws_iam_role" "confirm_sign_up_function_role" {
  name = "CONFIRM_SIGN_UP_FUNCTION_${var.RESOURCES_PREFIX}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}


# =================================================================
#  LOGIN ROLE
# =================================================================
resource "aws_iam_role" "login_function_role" {
  name = "LOGIN_FUNCTION_${var.RESOURCES_PREFIX}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}


# =================================================================
#  FORGOT PASSWORD ROLE
# =================================================================
resource "aws_iam_role" "forgot_password_function_role" {
  name = "FORGOT_PASSWORD_FUNCTION_${var.RESOURCES_PREFIX}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}


# =================================================================
#  coNFIRM FORGOT PASSWORD ROLE
# =================================================================
resource "aws_iam_role" "confirm_forgot_password_function_role" {
  name = "CONFIRM_FORGOT_PASSWORD_FUNCTION_${var.RESOURCES_PREFIX}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}