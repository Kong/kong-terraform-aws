resource "template_file" "cloud_init_mod" {
  template = file("${path.module}/cloud-init.cfg")
}

resource "template_file" "shell_script_mod" {
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

resource "template_cloudinit_config" "cloud-init" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = resource.template_file.cloud_init_mod.rendered
  }

  part {
    content_type = "text/x-shellscript"
    content      = resource.template_file.shell_script_mod.rendered
  }
}
