variable "ENV" {}
variable "AWS_REGION" {}
variable "LAMBDA_PYTHON_VERSION" {}
variable "LAMBDA_JAVASCRIPT_VERSION" {}
variable "RESOURCES_PREFIX" {}
variable "USER_TABLE_NAME" {

}
variable "MONGODB_URI" {
  default = "put your uri here"
}

variable "CLIENT_SECRET" {
}
variable "CLIENT_ID" {
}
variable "POOL_ID" {
}
variable "SIGN_UP_FUNCTION_ROLE_ARN" {}
variable "CONFIRM_SIGN_UP_FUNCTION_ROLE_ARN" {}
variable "LOGIN_FUNCTION_ROLE_ARN" {}
variable "FORGOT_PASSWORD_FUNCTION_ROLE_ARN" {}
variable "CONFIRM_FORGOT_PASSWORD_FUNCTION_ROLE_ARN" {

}