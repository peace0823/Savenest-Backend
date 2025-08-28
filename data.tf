# Gets info about the currently authenticated AWS user/account
data "aws_caller_identity" "current" {}

# Gets the current AWS region from provider configuration
data "aws_region" "current" {}
