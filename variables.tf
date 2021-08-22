variable "domain_identity" {
  type        = string
  description = "Domain identity to configure on SES"
  default = ""
}

variable "email_identity" {
  type        = string
  description = "(optional) Email identity to configure on SES"
  default     = ""
}


variable "tags" {
  type        = map(any)
  description = "(optional) map of tags to be assigned to hosted zone"
  default     = {}
}

variable "enable_dkim" {
  type        = bool
  description = "Enable DKIM signature"
  default     = true
}

variable "mail_from_domain" {
  type = string
  description = "(optional) Specify mail from domain"
  default = ""
}