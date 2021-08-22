locals {
  domain_dkim_tokens = local.enable_dkim == 1 ? module.ses.dkim_tokens : []
  enable_dkim = var.enable_dkim == true && var.domain_identity != "" ? 1 : 0
  zone_name = var.zone_name != "" ? var.zone_name : var.domain_identity
}

data "aws_route53_zone" "ses_domain_validation_zone" {
  count = var.domain_identity != "" ? 1 : 0
  name         = local.zone_name
  provider = aws.route53
}

module "ses" {
  source = "../../"
  domain_identity = var.domain_identity
  email_identity = var.email_identity
  enable_dkim = var.enable_dkim
}

resource "aws_route53_record" "route53_ses_domain-validation" {
  count = var.domain_identity != "" && var.external_domain_validation != true ? 1 : 0
  zone_id = data.aws_route53_zone.ses_domain_validation_zone[0].zone_id
  name    = "_amazonses.${var.domain_identity}"
  type    = "TXT"
  ttl     = "300"
  records = [module.ses.verification_token]
  provider = aws.route53
}
resource "aws_route53_record" "route53_ses_dkim_validation" {
  count    = local.enable_dkim == 1 ? 3 : 0
  zone_id  = data.aws_route53_zone.ses_domain_validation_zone[0].zone_id
  name     = "${element(local.domain_dkim_tokens, count.index)}._domainkey.${var.domain_identity}"
  type     = "CNAME"
  records  = ["${element(local.domain_dkim_tokens, count.index)}.dkim.amazonses.com"]
  ttl      = "600"

  provider = aws.route53
}
data "aws_region" "current" {}

resource "aws_route53_record" "route53_ses_domain_mail_from_mx" {
  count = var.domain_identity != "" ? 1 : 0
  zone_id = data.aws_route53_zone.ses_domain_validation_zone[0].zone_id
  name    = module.ses.mail_from_domain
  type    = "MX"
  ttl     = "600"
  records = ["10 feedback-smtp.${data.aws_region.current.name}.amazonses.com"]

  provider = aws.route53
}
resource "aws_route53_record" "route53_ses_domain_mail_from_txt" {
  count = var.domain_identity != "" ? 1 : 0
  zone_id = data.aws_route53_zone.ses_domain_validation_zone[0].zone_id
  name    = module.ses.mail_from_domain
  type    = "TXT"
  ttl     = "600"
  records = ["v=spf1 include:amazonses.com -all"]

  provider = aws.route53
}
