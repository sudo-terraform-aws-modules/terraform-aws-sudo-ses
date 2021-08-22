output "domain_identity_arn" {
  value = var.domain_identity != "" ? aws_ses_domain_identity.ses_domain_identity[0].arn : ""
}
output "verification_token" {
  value = var.domain_identity != "" ? aws_ses_domain_identity.ses_domain_identity[0].verification_token : ""
}

output "dkim_tokens" {
  value = local.enable_dkim == 1 ? aws_ses_domain_dkim.ses_dkim_validation[0].dkim_tokens : []
}

output "mail_from_domain" {

  value = var.domain_identity != "" ? aws_ses_domain_mail_from.ses_mail_from_domain[0].mail_from_domain : ""
}