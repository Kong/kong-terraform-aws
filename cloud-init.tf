data "template_file" "cloud-init" {
  template = file("${path.module}/cloud-init.cfg")
}

data "template_file" "shell-script" {
  template = file("${path.module}/cloud-init.sh")

  vars = {
    DB_USER        = replace(format("%s_%s", var.service, var.environment), "-", "_")
    CE_PKG         = var.ce_pkg
    EE_PKG         = var.ee_pkg
    PARAMETER_PATH = format("/%s/%s", var.service, var.environment)
    REGION         = data.aws_region.current.name
    VPC_CIDR_BLOCK = data.aws_vpc.vpc.cidr_block
    DECK_VERSION   = var.deck_version
    MANAGER_HOST   = local.manager_host
    PORTAL_HOST    = local.portal_host
    SESSION_SECRET = random_string.session_secret.result
  }
}

data "template_cloudinit_config" "cloud-init" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.cloud-init.rendered
  }

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.shell-script.rendered
  }
}
