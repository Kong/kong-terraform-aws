data "aws_region" "current" {}

data "aws_acm_certificate" "external-cert" {
  domain = var.ssl_cert_external
}

data "aws_acm_certificate" "internal-cert" {
  domain = var.ssl_cert_internal
}

data "aws_acm_certificate" "admin-cert" {
  domain = var.ssl_cert_admin
}

data "aws_acm_certificate" "manager-cert" {
  domain = var.ssl_cert_manager
}

data "aws_acm_certificate" "portal-cert" {
  domain = var.ssl_cert_portal
}
