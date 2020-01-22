resource "aws_launch_configuration" "kong" {
  name_prefix          = format("%s-%s-", var.service, var.environment)
  image_id             = var.ec2_ami[data.aws_region.current.name]
  instance_type        = var.ec2_instance_type
  iam_instance_profile = aws_iam_instance_profile.kong.name
  key_name             = var.ec2_key_name

  security_groups = [
    data.aws_security_group.default.id,
    aws_security_group.kong.id,
  ]

  associate_public_ip_address = false
  enable_monitoring           = true
  placement_tenancy           = "default"
  user_data                   = data.template_cloudinit_config.cloud-init.rendered

  root_block_device {
    volume_size = var.ec2_root_volume_size
    volume_type = var.ec2_root_volume_type
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "kong" {
  name                = format("%s-%s", var.service, var.environment)
  vpc_zone_identifier = data.aws_subnet_ids.private.ids

  launch_configuration = aws_launch_configuration.kong.name

  desired_capacity          = var.asg_desired_capacity
  force_delete              = false
  health_check_grace_period = var.asg_health_check_grace_period
  health_check_type         = "ELB"
  max_size                  = var.asg_max_size
  min_size                  = var.asg_min_size

  target_group_arns = compact(
    concat(
      aws_lb_target_group.external.*.arn,
      aws_lb_target_group.internal.*.arn,
      aws_lb_target_group.admin.*.arn,
      aws_lb_target_group.manager.*.arn,
      aws_lb_target_group.portal-gui.*.arn,
      aws_lb_target_group.portal.*.arn
    )
  )

  tag {
    key                 = "Name"
    value               = format("%s-%s", var.service, var.environment)
    propagate_at_launch = true
  }
  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }
  tag {
    key                 = "Description"
    value               = var.description
    propagate_at_launch = true
  }
  tag {
    key                 = "Service"
    value               = var.service
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  depends_on = [
    aws_db_instance.kong,
    aws_rds_cluster.kong
  ]
}
