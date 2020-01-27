module "kong_external_lb_cw" {
  source = "./cw/lb"

  enable        = var.enable_external_lb
  load_balancer = coalesce(join("", aws_lb.external.*.arn_suffix), "none")
  target_group  = coalesce(join("", aws_lb_target_group.external.*.arn), "none")

  cloudwatch_actions = var.cloudwatch_actions
  http_4xx_count     = var.http_4xx_count
  http_5xx_count     = var.http_5xx_count
}

module "kong_internal_lb_cw" {
  source = "./cw/lb"

  enable        = var.enable_external_lb
  load_balancer = coalesce(join("", aws_lb.internal.*.arn_suffix), "none")
  target_group  = coalesce(join("", aws_lb_target_group.internal.*.arn), "none")

  cloudwatch_actions = var.cloudwatch_actions
  http_4xx_count     = var.http_4xx_count
  http_5xx_count     = var.http_5xx_count
}
