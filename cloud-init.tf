locals {
  cloud_init = templatefile("${path.module}/cloud-init.cfg", {})

  shell_script = templatefile("${path.module}/cloud-init.sh", {
    DB_USER           = replace(format("%s_%s", var.service, var.environment), "-", "_")
    CE_PKG            = var.ce_pkg
    EE_PKG            = var.ee_pkg
    PARAMETER_PATH    = format("/%s/%s", var.service, var.environment)
    REGION            = data.aws_region.current.name
    VPC_CIDR_BLOCK    = var.vpc_cidr_block
    DECK_VERSION      = var.deck_version
    MANAGER_HOST      = local.manager_host
    PORTAL_HOST       = local.portal_host
    SESSION_SECRET    = random_string.session_secret.result
    ADMIN_CERT_DOMAIN = var.ssl_cert_admin_domain
    ADMIN_USER        = var.admin_user
    VANTA_KEY         = var.vanta_key
    VANTA_SCRIPT_URL  = var.vanta_script_url
  })

}

data "template_cloudinit_config" "cloud-init" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = local.cloud_init
  }

  part {
    content_type = "text/x-shellscript"
    content      = local.shell_script
  }
}
