module "kong-external-alb-cw" {
  source = "./cw/alb"

  enable        = var.enable_external_lb
  load_balancer = coalesce(join("", aws_alb.external.*.arn_suffix), "none")
  target_group  = coalesce(join("", aws_alb_target_group.external.*.arn), "none")

  cloudwatch_actions = var.cloudwatch_actions
  http_4xx_count     = var.http_4xx_count
  http_5xx_count     = var.http_5xx_count
}

module "kong-internal-alb-cw" {
  source = "./cw/alb"

  enable        = var.enable_external_lb
  load_balancer = coalesce(join("", aws_alb.internal.*.arn_suffix), "none")
  target_group  = coalesce(join("", aws_alb_target_group.internal.*.arn), "none")

  cloudwatch_actions = var.cloudwatch_actions
  http_4xx_count     = var.http_4xx_count
  http_5xx_count     = var.http_5xx_count
}
