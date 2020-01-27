# External - HTTPS only
resource "aws_lb_target_group" "external" {
  count = var.enable_external_lb ? 1 : 0

  name     = format("%s-%s-external", var.service, var.environment)
  port     = 8000
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.vpc.id

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
  internal = false
  subnets  = data.aws_subnet_ids.public.ids

  security_groups = [aws_security_group.external-lb.id]

  enable_deletion_protection = var.enable_deletion_protection
  idle_timeout               = var.idle_timeout

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

resource "aws_lb_listener" "external-https" {
  count = var.enable_external_lb ? 1 : 0

  load_balancer_arn = aws_lb.external[0].arn
  port              = "443"
  protocol          = "HTTPS"

  ssl_policy      = var.ssl_policy
  certificate_arn = data.aws_acm_certificate.external-cert.arn

  default_action {
    target_group_arn = aws_lb_target_group.external[0].arn
    type             = "forward"
  }
}

# Internal
resource "aws_lb_target_group" "internal" {
  count = var.enable_internal_lb ? 1 : 0

  name     = format("%s-%s-internal", var.service, var.environment)
  port     = 8000
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.vpc.id

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
  vpc_id   = data.aws_vpc.vpc.id

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
  vpc_id   = data.aws_vpc.vpc.id

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
  vpc_id   = data.aws_vpc.vpc.id

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
  vpc_id   = data.aws_vpc.vpc.id

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
  subnets  = data.aws_subnet_ids.private.ids

  security_groups = [aws_security_group.internal-lb.id]

  enable_deletion_protection = var.enable_deletion_protection
  idle_timeout               = var.idle_timeout

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

resource "aws_lb_listener" "internal-http" {
  count = var.enable_internal_lb ? 1 : 0

  load_balancer_arn = aws_lb.internal[0].arn
  port              = 80
  protocol          = "HTTP"

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
  certificate_arn = data.aws_acm_certificate.internal-cert.arn

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
  certificate_arn = data.aws_acm_certificate.internal-cert.arn

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
  certificate_arn = data.aws_acm_certificate.internal-cert.arn

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
  certificate_arn = data.aws_acm_certificate.internal-cert.arn

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
  certificate_arn = data.aws_acm_certificate.internal-cert.arn

  default_action {
    target_group_arn = aws_lb_target_group.portal[0].arn
    type             = "forward"
  }
}
