resource "aws_kms_key" "kong" {
  description = format("%s-%s", var.service, var.environment)

  tags = merge(
    {
      "Name"        = format("%s-%s", var.service, var.environment),
      "Environment" = var.environment,
      "Description" = var.description,
      "Service"     = var.service,
    },
    var.tags
  )
}

resource "aws_kms_alias" "kong" {
  name          = format("alias/%s-%s", var.service, var.environment)
  target_key_id = aws_kms_key.kong.key_id
}

resource "aws_ssm_parameter" "ee-bintray-auth" {
  name  = format("/%s/%s/ee/bintray-auth", var.service, var.environment)
  type  = "SecureString"
  value = var.ee_bintray_auth

  key_id = aws_kms_alias.kong.target_key_arn

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "ee-license" {
  name  = format("/%s/%s/ee/license", var.service, var.environment)
  type  = "SecureString"
  value = var.ee_license

  key_id = aws_kms_alias.kong.target_key_arn

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "ee-admin-token" {
  name  = format("/%s/%s/ee/admin/token", var.service, var.environment)
  type  = "SecureString"
  value = random_string.admin_token.result

  key_id = aws_kms_alias.kong.target_key_arn

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "db-host" {
  name = format("/%s/%s/db/host", var.service, var.environment)
  type = "String"
  value = coalesce(
    join("", aws_db_instance.kong.*.address),
    join("", aws_rds_cluster.kong.*.endpoint),
    "none"
  )
}

resource "aws_ssm_parameter" "db-name" {
  name  = format("/%s/%s/db/name", var.service, var.environment)
  type  = "String"
  value = replace(format("%s_%s", var.service, var.environment), "-", "_")
}

resource "aws_ssm_parameter" "db-password" {
  name  = format("/%s/%s/db/password", var.service, var.environment)
  type  = "SecureString"
  value = random_string.db_password.result

  key_id = aws_kms_alias.kong.target_key_arn

  lifecycle {
    ignore_changes = [value]
  }

  overwrite = true
}

resource "aws_ssm_parameter" "db-master-password" {
  name  = format("/%s/%s/db/password/master", var.service, var.environment)
  type  = "SecureString"
  value = random_string.master_password.result

  key_id = aws_kms_alias.kong.target_key_arn

  lifecycle {
    ignore_changes = [value]
  }

  overwrite = true
}
