locals {
    render_variables = {
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

data "cloudinit_config" "cloud-init" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = file("${path.module}/cloud-init.cfg")
  }

  part {
    content_type = "text/x-shellscript"
    content      = templatefile("${path.module}/cloud-init.sh", local.render_variables)
  }
}
