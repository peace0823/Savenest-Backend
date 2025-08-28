# --------------------------------------------------
# Environment & Region Settings
# --------------------------------------------------
variable "region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "ENV" {
  description = "Deployment environment (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

# --------------------------------------------------
# Lambda Configuration
# --------------------------------------------------
variable "LAMBDA_PYTHON_VERSION" {
  description = "Runtime version for Python Lambdas"
  type        = string
  default     = "python3.13"
}

variable "LAMBDA_JAVASCRIPT_VERSION" {
  description = "Runtime version for NodeJS Lambdas"
  type        = string
  default     = "nodejs18.x"
}

# --------------------------------------------------
# Cognito Configuration
# --------------------------------------------------
variable "COGNITO_GROUP_LIST" {
  description = "Comma-separated Cognito user group list"
  type        = string
  default     = "customer"
}

variable "IAM_COGNITO_ASSUMABLE_ROLE_EXTERNAL_ID" {
  description = "External ID for Cognito IAM role"
  type        = string
  default     = "ghU968996890"
}

variable "WEBAPP_DNS" {
  description = "Domain name used for Cognito (e.g., auth subdomain)"
  type        = string
  default     = "mydomain.com"
}

variable "RESEND_API_KEY" {
  description = "API key for Resend email provider"
  type        = string
  default     = "JJJ"
}

# variable "WEBAPP_CERT" {
#   type    = string
#   default = "JKJs"
# }

# variable "WEBAPP_CERT_ARN" {
#   type    = string
#   default = "kjsn"
# }

# --------------------------------------------------
# MongoDB Atlas
# --------------------------------------------------
variable "MONGODB_URI" {
  description = "MongoDB Atlas connection string"
  type        = string
  default     = "mongodb+srv://cloud_team_user:somethingrandom123@cluster0.889oilx.mongodb.net/SavenestDB?retryWrites=true&w=majority&appName=Cluster0"
}