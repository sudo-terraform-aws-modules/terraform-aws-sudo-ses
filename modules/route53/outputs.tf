output "domain_identity_arn" {
  value = var.domain_identity != "" ? module.ses.domain_identity_arn : ""
}
output "dkim_tokens" {
  value = module.ses.dkim_tokens
}