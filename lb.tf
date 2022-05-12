# External - HTTPS only
resource "aws_lb_target_group" "external" {
  count = var.enable_external_lb ? 1 : 0

  name     = format("%s-%s-external", var.service, var.environment)
  port     = 8000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = var.health_check_healthy_threshold
    interval            = var.health_check_interval
    path                = "/status"
    port                = 8000
    timeout             = var.health_check_timeout
    unhealthy_threshold = var.health_check_unhealthy_threshold
  }

  tags = merge(
    {
      "Name"        = format("%s-%s-external", var.service, var.environment),
      "Environment" = var.environment,
      "Description" = var.description,
      "Service"     = var.service,
    },
    var.tags
  )
}

resource "aws_lb" "external" {
  count = var.enable_external_lb ? 1 : 0

  name     = format("%s-%s-external", var.service, var.environment)
  internal = false #tfsec:ignore:AWS005
  subnets  = var.aws_public_subnet_ids

  security_groups = [aws_security_group.external-lb.id]

  enable_deletion_protection = var.enable_deletion_protection
  idle_timeout               = var.idle_timeout
  drop_invalid_header_fields = var.drop_invalid_header_fields

  tags = merge(
    {
      "Name"        = format("%s-%s-external", var.service, var.environment),
      "Environment" = var.environment,
      "Description" = var.description,
      "Service"     = var.service,
    },
    var.tags
  )
  timeouts {
    create = var.lb_creation_timeout
    delete = var.lb_deletion_timeout
  }
  dynamic "access_logs" {
    for_each = toset(length(var.lb_logging_bucket) > 0 ? [var.lb_logging_bucket] : [])
    content {
      bucket  = access_logs.value
      prefix  = length(var.external_lb_logging_prefix) > 0 ? var.external_lb_logging_prefix : format("%s-%s-external", var.service, var.environment)
      enabled = true
    }
  }
}

resource "aws_lb_listener" "external-https" {
  count = var.enable_external_lb ? 1 : 0

  load_balancer_arn = aws_lb.external[0].arn
  port              = "443"
  protocol          = "HTTPS"

  ssl_policy      = var.ssl_policy
  certificate_arn = var.ssl_cert_external_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Forbidden"
      status_code  = "403"
    }
  }
}

resource "aws_lb_listener_rule" "external-routing" {
  count = var.enable_external_lb ? 1 : 0

  listener_arn = aws_lb_listener.external-https[0].arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.external[0].arn
  }
  condition {
    host_header {
      values = [var.ssl_cert_admin_domain]
    }
  }
}



resource "aws_lb_listener" "external-http" {
  count = var.enable_external_lb ? 1 : 0

  load_balancer_arn = aws_lb.external[0].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# Internal
resource "aws_lb_target_group" "internal" {
  count = var.enable_internal_lb ? 1 : 0

  name     = format("%s-%s-internal", var.service, var.environment)
  port     = 8000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = var.health_check_healthy_threshold
    interval            = var.health_check_interval
    path                = "/status"
    port                = 8000
    timeout             = var.health_check_timeout
    unhealthy_threshold = var.health_check_unhealthy_threshold
  }

  tags = merge(
    {
      "Name"        = format("%s-%s-internal", var.service, var.environment),
      "Environment" = var.environment,
      "Description" = var.description,
      "Service"     = var.service,
    },
    var.tags
  )
}

resource "aws_lb_target_group" "admin" {
  count = var.enable_ee ? 1 : 0

  name     = format("%s-%s-admin", var.service, var.environment)
  port     = 8001
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = var.health_check_healthy_threshold
    interval            = var.health_check_interval
    path                = "/status"
    port                = 8000
    timeout             = var.health_check_timeout
    unhealthy_threshold = var.health_check_unhealthy_threshold
  }

  tags = merge(
    {
      "Name"        = format("%s-%s-admin", var.service, var.environment),
      "Environment" = var.environment,
      "Description" = var.description,
      "Service"     = var.service,
    },
    var.tags
  )
}

resource "aws_lb_target_group" "manager" {
  count = var.enable_ee ? 1 : 0

  name     = format("%s-%s-manager", var.service, var.environment)
  port     = 8002
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = var.health_check_healthy_threshold
    interval            = var.health_check_interval
    path                = "/status"
    port                = 8000
    timeout             = var.health_check_timeout
    unhealthy_threshold = var.health_check_unhealthy_threshold
  }

  tags = merge(
    {
      "Name"        = format("%s-%s-manager", var.service, var.environment),
      "Environment" = var.environment,
      "Description" = var.description,
      "Service"     = var.service,
    },
    var.tags
  )
}

resource "aws_lb_target_group" "portal-gui" {
  count = var.enable_ee ? 1 : 0

  name     = format("%s-%s-porter-gui", var.service, var.environment)
  port     = 8003
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = var.health_check_healthy_threshold
    interval            = var.health_check_interval
    path                = "/status"
    port                = 8000
    timeout             = var.health_check_timeout
    unhealthy_threshold = var.health_check_unhealthy_threshold
  }

  tags = merge(
    {
      "Name"        = format("%s-%s-porter-gui", var.service, var.environment),
      "Environment" = var.environment,
      "Description" = var.description,
      "Service"     = var.service,
    },
    var.tags
  )
}

resource "aws_lb_target_group" "portal" {
  count = var.enable_ee ? 1 : 0

  name     = format("%s-%s-portal", var.service, var.environment)
  port     = 8004
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = var.health_check_healthy_threshold
    interval            = var.health_check_interval
    path                = "/status"
    port                = 8000
    timeout             = var.health_check_timeout
    unhealthy_threshold = var.health_check_unhealthy_threshold
  }

  tags = merge(
    {
      "Name"        = format("%s-%s-portal", var.service, var.environment),
      "Environment" = var.environment,
      "Description" = var.description,
      "Service"     = var.service,
    },
    var.tags
  )
}

resource "aws_lb" "internal" {
  count = var.enable_internal_lb ? 1 : 0

  name     = format("%s-%s-internal", var.service, var.environment)
  internal = true
  subnets  = var.aws_private_subnet_ids

  security_groups = [aws_security_group.internal-lb.id]

  enable_deletion_protection = var.enable_deletion_protection
  idle_timeout               = var.idle_timeout
  drop_invalid_header_fields = var.drop_invalid_header_fields

  tags = merge(
    {
      "Name"        = format("%s-%s-internal", var.service, var.environment),
      "Environment" = var.environment,
      "Description" = var.description,
      "Service"     = var.service,
    },
    var.tags
  )
  timeouts {
    create = var.lb_creation_timeout
    delete = var.lb_deletion_timeout
  }
}

resource "aws_lb_listener" "internal-http" {
  count = var.enable_internal_lb ? 1 : 0

  load_balancer_arn = aws_lb.internal[0].arn
  port              = 80
  protocol          = "HTTP" #tfsec:ignore:AWS004

  default_action {
    target_group_arn = aws_lb_target_group.internal[0].arn
    type             = "forward"
  }
}

resource "aws_lb_listener" "internal-https" {
  count = var.enable_internal_lb ? 1 : 0

  load_balancer_arn = aws_lb.internal[0].arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy      = var.ssl_policy
  certificate_arn = var.ssl_cert_internal_arn

  default_action {
    target_group_arn = aws_lb_target_group.internal[0].arn
    type             = "forward"
  }
}

resource "aws_lb_listener" "admin" {
  count = var.enable_ee ? 1 : 0

  load_balancer_arn = aws_lb.internal[0].arn
  port              = 8444
  protocol          = "HTTPS"

  ssl_policy      = var.ssl_policy
  certificate_arn = var.ssl_cert_internal_arn

  default_action {
    target_group_arn = aws_lb_target_group.admin[0].arn
    type             = "forward"
  }
}

resource "aws_lb_listener" "manager" {
  count = var.enable_ee ? 1 : 0

  load_balancer_arn = aws_lb.internal[0].arn
  port              = 8445
  protocol          = "HTTPS"

  ssl_policy      = var.ssl_policy
  certificate_arn = var.ssl_cert_internal_arn

  default_action {
    target_group_arn = aws_lb_target_group.manager[0].arn
    type             = "forward"
  }
}

resource "aws_lb_listener" "portal-gui" {
  count = var.enable_ee ? 1 : 0

  load_balancer_arn = aws_lb.internal[0].arn
  port              = 8446
  protocol          = "HTTPS"

  ssl_policy      = var.ssl_policy
  certificate_arn = var.ssl_cert_internal_arn

  default_action {
    target_group_arn = aws_lb_target_group.portal-gui[0].arn
    type             = "forward"
  }
}

resource "aws_lb_listener" "portal" {
  count = var.enable_ee ? 1 : 0

  load_balancer_arn = aws_lb.internal[0].arn
  port              = 8447
  protocol          = "HTTPS"

  ssl_policy      = var.ssl_policy
  certificate_arn = var.ssl_cert_internal_arn

  default_action {
    target_group_arn = aws_lb_target_group.portal[0].arn
    type             = "forward"
  }
}
