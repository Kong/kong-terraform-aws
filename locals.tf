locals {
  enable_rds = var.enable_aurora ? false : true

  manager_host = var.manager_host == "default" ? join("", aws_lb.internal.*.dns_name) : var.manager_host
  portal_host  = var.portal_host == "default" ? join("", aws_lb.internal.*.dns_name) : var.portal_host
}
