locals {
  load_balancer = element(split("/", var.load_balancer), 1)
}

resource "aws_cloudwatch_metric_alarm" "unhealthy-host-count" {
  count = var.enable ? 1 : 0

  alarm_name          = format("%s-unhealthy-host-count", local.load_balancer)
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Minimum"
  threshold           = 0

  actions_enabled   = "true"
  alarm_actions     = var.cloudwatch_actions
  alarm_description = format("Unhealthy host count is greater than 0 for %s", local.load_balancer)
  ok_actions        = var.cloudwatch_actions

  dimensions = {
    "TargetGroup"  = element(split(":", var.target_group), 5)
    "LoadBalancer" = var.load_balancer
  }
}

resource "aws_cloudwatch_metric_alarm" "http-code-4xx-count" {
  count = var.enable ? 1 : 0

  alarm_name          = format("%s-http-code-4xx-count", local.load_balancer)
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTPCode_Target_4XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Minimum"
  threshold           = var.http_4xx_count
  treat_missing_data  = "ignore"

  actions_enabled   = "true"
  alarm_actions     = var.cloudwatch_actions
  alarm_description = format("HTTP Code 4xx count is greater than %s for %s", var.http_4xx_count, local.load_balancer)
  ok_actions        = var.cloudwatch_actions

  dimensions = {
    LoadBalancer = var.load_balancer
  }
}

resource "aws_cloudwatch_metric_alarm" "http-code-5xx-count" {
  count = var.enable ? 1 : 0

  alarm_name          = format("%s-http-code-5xx-count", local.load_balancer)
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Minimum"
  threshold           = var.http_5xx_count
  treat_missing_data  = "ignore"

  actions_enabled   = "true"
  alarm_actions     = var.cloudwatch_actions
  alarm_description = format("HTTP Code 5xx count is greater than %s for %s", var.http_5xx_count, local.load_balancer)
  ok_actions        = var.cloudwatch_actions

  dimensions = {
    LoadBalancer = var.load_balancer
  }
}
