data "aws_iam_policy_document" "kong-ssm" {
  statement {
    actions   = ["ssm:DescribeParameters"]
    resources = ["*"]
  }

  statement {
    actions   = ["ssm:GetParameter"]
    resources = ["arn:aws:ssm:*:*:parameter/${var.service}/${var.environment}/*"]
  }

  statement {
    actions   = ["kms:Decrypt"]
    resources = [aws_kms_key.kong.arn]
  }
}

resource "aws_iam_role_policy" "kong-ssm" {
  name = format("%s-%s-ssm", var.service, var.environment)
  role = aws_iam_role.kong.id

  policy = data.aws_iam_policy_document.kong-ssm.json
}

data "aws_iam_policy_document" "kong" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "kong" {
  name               = format("%s-%s", var.service, var.environment)
  assume_role_policy = data.aws_iam_policy_document.kong.json
}

resource "aws_iam_role_policy_attachment" "kong_ssm_managed_instance_policy_attach" {
  role       = aws_iam_role.kong.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "kong" {
  name = format("%s-%s", var.service, var.environment)
  role = aws_iam_role.kong.id
}
