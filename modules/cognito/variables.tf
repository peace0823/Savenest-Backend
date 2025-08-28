variable "ENV" {
  description = "Deployment environment (e.g., dev, prod)"
  type        = string
}

variable "COMMON_TAGS" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "AWS_REGION" {
  description = "AWS region to deploy to"
  type        = string
  default     = "us-east-1"
}

variable "CURRENT_ACCOUNT_ID" {
  description = "AWS Account ID"
  type        = string
}

variable "IAM_COGNITO_ASSUMABLE_ROLE_EXTERNAL_ID" {
  description = "External ID for IAM role assumable by Cognito for SMS"
  type        = string
}

variable "EMAIL_SENDER" {
  description = "Verified SES email sender address"
  type        = string
}

variable "COGNITO_GROUP_LIST" {
  description = "Comma-separated list of Cognito groups to create"
  type        = string
  default     = "end-users"
}

variable "WEBAPP_DNS" {
  description = "Frontend domain for OAuth callback (e.g., web.financeapp.com)"
  type        = string
}

variable "RESOURCE_PREFIX" {
  description = "Prefix used for naming AWS resources"
  type        = string
}

variable "PYTHON_LAMBDA_VERSION" {
  description = "Runtime for Lambda functions (e.g., python3.11)"
  type        = string
  default     = "python3.11"
}

variable "BUCKET_NAME" {
  description = "S3 bucket name for Lambda environment variable"
  type        = string
}

variable "RESOURCE" {
  description = "Resource identifier used in naming"
  type        = string
}

variable "COGNITO_DOMAIN_NAME" {
  description = "Custom domain name for Cognito User Pool"
  type        = string
}

variable "RESEND_API_KEY" {
  description = "API key for email resend service (optional)"
  type        = string
  sensitive   = true
}

variable "USER_TABLE_NAME" {
  description = "DynamoDB or other user table name used by Lambda functions"
  type        = string
}

variable "MONGODB_URI" {
  description = "Primary MongoDB connection string"
  type        = string
  sensitive   = true
}