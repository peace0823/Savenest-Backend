resource "aws_ses_email_identity" "savenest_email" {
  email = var.SAVENEST_EMAIL
}

resource "aws_ses_email_identity" "info_email" {
  email = var.INFO_EMAIL
}