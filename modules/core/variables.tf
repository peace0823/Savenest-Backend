variable "CURRENT_ACCOUNT_ID" {
  description = "AWS Account ID"
  type        = string
}

variable "ENV" {
  description = "Deployment environment (e.g., dev, prod)"
  type        = string
}

variable "BASE_PATH" {
  description = "Base path for the API Gateway"
  type        = string
  default     = "core"
}

variable "LAMBDA_NAMES" {
  description = "List of Lambda function names to grant API Gateway invoke permissions"
  type        = list(string)
}

variable "RESOURCES_PREFIX" {
  description = "Prefix for resource naming"
  type        = string
}

variable "API_DOMAIN_NAME" {
  description = "Custom domain name for the API Gateway (optional)"
  type        = string
}

variable "LAMBDA_CREATE_LINK_FUNCTION_ARN" {
  description = "ARN of the Lambda function that creates links (usage dependent)"
  type        = string
}