locals {
  RESOURCES_PREFIX = "${lower(var.ENV)}-savenest"
  ACCOUNTID        = data.aws_caller_identity.current.account_id
  INFO_EMAIL       = "info@email.com"

  DOMAIN_NAME         = "api.${var.WEBAPP_DNS}"
  cognito_domain_name = var.WEBAPP_DNS

  common_tags = {
    environment = var.ENV
    project     = "m4ace"
    managedby   = "cloud@email.com"
  }
}

# --------------------------------------------------
# IAM Roles
# --------------------------------------------------
module "roles" {
  source           = "./modules/roles"
  ENV              = var.ENV
  AWS_REGION       = var.region
  RESOURCES_PREFIX = local.RESOURCES_PREFIX
}

# --------------------------------------------------
# IAM Policies
# --------------------------------------------------
module "policy" {
  source             = "./modules/policy"
  ENV                = var.ENV
  AWS_REGION         = var.region
  RESOURCES_PREFIX   = local.RESOURCES_PREFIX
  CURRENT_ACCOUNT_ID = data.aws_caller_identity.current.account_id

  SIGN_UP_FUNCTION_ROLE_NAME                 = module.roles.SIGN_UP_FUNCTION_ROLE_NAME
  CONFIRM_SIGN_UP_FUNCTION_ROLE_NAME         = module.roles.CONFIRM_SIGN_UP_FUNCTION_ROLE_NAME
  LOGIN_FUNCTION_ROLE_NAME                   = module.roles.LOGIN_FUNCTION_ROLE_NAME
  FORGOT_PASSWORD_FUNCTION_ROLE_NAME         = module.roles.FORGOT_PASSWORD_FUNCTION_ROLE_NAME
  CONFIRM_FORGOT_PASSWORD_FUNCTION_ROLE_NAME = module.roles.CONFIRM_FORGOT_PASSWORD_FUNCTION_ROLE_NAME
}

# --------------------------------------------------
# Lambda Functions
# --------------------------------------------------
module "lambda" {
  source           = "./modules/lambda"
  ENV              = var.ENV
  AWS_REGION       = var.region
  RESOURCES_PREFIX = local.RESOURCES_PREFIX
  USER_TABLE_NAME  = module.user_table.table_name
  CLIENT_ID        = module.cognito_end_user.COGNITO_USER_CLIENT_ID_A
  POOL_ID          = module.cognito_end_user.COGNITO_USER_POOL_ID
  CLIENT_SECRET    = module.cognito_end_user.COGNITO_USER_CLIENT_SECRET_A

  LAMBDA_JAVASCRIPT_VERSION                 = var.LAMBDA_JAVASCRIPT_VERSION
  LAMBDA_PYTHON_VERSION                     = var.LAMBDA_PYTHON_VERSION
  SIGN_UP_FUNCTION_ROLE_ARN                 = module.roles.SIGN_UP_FUNCTION_ROLE_ARN
  CONFIRM_SIGN_UP_FUNCTION_ROLE_ARN         = module.roles.CONFIRM_SIGN_UP_FUNCTION_ROLE_ARN
  LOGIN_FUNCTION_ROLE_ARN                   = module.roles.LOGIN_FUNCTION_ROLE_ARN
  FORGOT_PASSWORD_FUNCTION_ROLE_ARN         = module.roles.FORGOT_PASSWORD_FUNCTION_ROLE_ARN
  CONFIRM_FORGOT_PASSWORD_FUNCTION_ROLE_ARN = module.roles.CONFIRM_FORGOT_PASSWORD_FUNCTION_ROLE_ARN

  MONGODB_URI = var.MONGODB_URI
}

# --------------------------------------------------
# DynamoDB Tables
# --------------------------------------------------
module "user_table" {
  source           = "./modules/dynamodb/user_table"
  ENV              = var.ENV
  AWS_REGION       = var.region
  RESOURCES_PREFIX = local.RESOURCES_PREFIX
  table_name       = "user_table"
}

module "product_table" {
  source           = "./modules/dynamodb/product_table"
  ENV              = var.ENV
  AWS_REGION       = var.region
  RESOURCES_PREFIX = local.RESOURCES_PREFIX
  table_name       = "product_table"
}

# --------------------------------------------------
# Cognito User Pool
# --------------------------------------------------
module "cognito_end_user" {
  source                                 = "./modules/cognito"
  ENV                                    = var.ENV
  COMMON_TAGS                            = local.common_tags
  EMAIL_SENDER                           = local.INFO_EMAIL
  IAM_COGNITO_ASSUMABLE_ROLE_EXTERNAL_ID = var.IAM_COGNITO_ASSUMABLE_ROLE_EXTERNAL_ID
  AWS_REGION                             = data.aws_region.current.name
  CURRENT_ACCOUNT_ID                     = local.ACCOUNTID
  WEBAPP_DNS                             = var.WEBAPP_DNS
  COGNITO_GROUP_LIST                     = var.COGNITO_GROUP_LIST
  RESOURCE_PREFIX                        = local.RESOURCES_PREFIX
  BUCKET_NAME                            = "bucket" # dummy, required by module input; replace if module enforces it
  RESOURCE                               = "end_user"
  PYTHON_LAMBDA_VERSION                  = var.LAMBDA_PYTHON_VERSION
  COGNITO_DOMAIN_NAME                    = local.cognito_domain_name
  RESEND_API_KEY                         = var.RESEND_API_KEY
  USER_TABLE_NAME                        = module.user_table.table_name
  MONGODB_URI                            = var.MONGODB_URI
}

# --------------------------------------------------
# Open API Gateway + Lambda Integration
# --------------------------------------------------
module "open" {
  source                                      = "./modules/open"
  ENV                                         = var.ENV
  RESOURCES_PREFIX                            = local.RESOURCES_PREFIX
  CURRENT_ACCOUNT_ID                          = data.aws_caller_identity.current.account_id
  API_DOMAIN_NAME                             = local.DOMAIN_NAME
  LAMBDA_SIGN_UP_FUNCTION_ARN                 = module.lambda.LAMBDA_SIGN_UP_FUNCTION_ARN
  LAMBDA_CONFIRM_SIGN_UP_FUNCTION_ARN         = module.lambda.LAMBDA_CONFIRM_SIGN_UP_FUNCTION_ARN
  LAMBDA_LOGIN_FUNCTION_ARN                   = module.lambda.LAMBDA_LOGIN_FUNCTION_ARN
  LAMBDA_FORGOT_PASSWORD_FUNCTION_ARN         = module.lambda.LAMBDA_FORGOT_PASSWORD_FUNCTION_ARN
  LAMBDA_CONFIRM_FORGOT_PASSWORD_FUNCTION_ARN = module.lambda.LAMBDA_CONFIRM_FORGOT_PASSWORD_FUNCTION_ARN

  LAMBDA_NAMES = [
    module.lambda.LAMBDA_SIGN_UP_FUNCTION_NAME,
    module.lambda.LAMBDA_CONFIRM_SIGN_UP_FUNCTION_NAME,
    module.lambda.LAMBDA_LOGIN_FUNCTION_NAME,
    module.lambda.LAMBDA_FORGOT_PASSWORD_FUNCTION_NAME,
    module.lambda.LAMBDA_CONFIRM_FORGOT_PASSWORD_FUNCTION_NAME,
  ]
}

# --------------------------------------------------
# SES module for email setup
# --------------------------------------------------
# module "ses" {
#   source     = "./modules/ses"
#   FEMI_EMAIL = local.FEMI_EMAIL
#   INFO_EMAIL = local.INFO_EMAIL
# }

# module "core" {
#   source                                            = "./modules/core"
#   ENV                                               = var.ENV
#   RESOURCES_PREFIX                                  = local.RESOURCES_PREFIX
#   CURRENT_ACCOUNT_ID                                = data.aws_caller_identity.current.account_id
#   API_DOMAIN_NAME                                   = local.DOMAIN_NAME
#   LAMBDA_CREATE_LINK_FUNCTION_ARN                   = module.lambda.LAMBDA_CREATE_LINK_FUNCTION_ARN

#   LAMBDA_NAMES = [

#   ] 
# }