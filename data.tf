# AWS Data
data "aws_vpc" "vpc" {
  state = "available"

  tags = {
    "Name" = var.vpc
  }
}

data "aws_region" "current" {}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.vpc.id

  filter {
    name   = "tag:${var.subnet_tag}"
    values = [var.public_subnets]
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.vpc.id

  filter {
    name   = "tag:${var.subnet_tag}"
    values = [var.private_subnets]
  }
}

data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    "Name" = var.default_security_group
  }
}

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
