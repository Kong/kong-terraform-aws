# AWS Data
data "aws_vpc" "vpc" {
  state = "available"

  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

data "aws_region" "current" {}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

  filter {
    name   = "tag:${var.subnet_tag}"
    values = [var.public_subnets]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

  filter {
    name   = "tag:${var.subnet_tag}"
    values = [var.private_subnets]
  }
}

data "aws_acm_certificate" "external-cert" {
  count  = var.enable_external_lb ? 1 : 0
  domain = var.ssl_cert_external
}

data "aws_acm_certificate" "internal-cert" {
  count  = var.enable_external_lb ? 1 : 0
  domain = var.ssl_cert_internal
}

data "aws_acm_certificate" "admin-cert" {
  count  = var.enable_external_lb ? 1 : 0
  domain = var.ssl_cert_admin
}

data "aws_acm_certificate" "manager-cert" {
  count  = var.enable_external_lb ? 1 : 0
  domain = var.ssl_cert_manager
}

data "aws_acm_certificate" "portal-cert" {
  count  = var.enable_external_lb ? 1 : 0
  domain = var.ssl_cert_portal
}
