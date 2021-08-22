
locals {
  enable_dkim      = var.enable_dkim == true && var.domain_identity != "" ? 1 : 0
  mail_from_domain = var.mail_from_domain != "" ? var.mail_from_domain : "sesbounce.${aws_ses_domain_identity.ses_domain_identity[0].domain}"
}

resource "aws_ses_domain_identity" "ses_domain_identity" {
  count  = var.domain_identity != "" ? 1 : 0
  domain = var.domain_identity
}

resource "aws_ses_email_identity" "ses_email_identity" {
  count = var.email_identity != "" ? 1 : 0
  email = var.email_identity
}

resource "aws_ses_domain_dkim" "ses_dkim_validation" {
  count  = local.enable_dkim
  domain = aws_ses_domain_identity.ses_domain_identity[0].domain
}

resource "aws_ses_domain_mail_from" "ses_mail_from_domain" {
  count            = var.domain_identity != "" ? 1 : 0
  domain           = aws_ses_domain_identity.ses_domain_identity[0].domain
  mail_from_domain = local.mail_from_domain
}
