provider "aws" {
  region     = "ca-central-1"
  profile    = "dev"
  access_key = var.access_key
  secret_key = var.secret_key

}

# module "vpc" {
#   source       = "./vpc"
#   environment  = "dev"
# }

# module "kong" {
#   source = "./kong"

#   vpc               = module.vpc.o_kong_vpc
#   environment       = "dev"
#   ec2_key_name      = var.ec2_key_name
#   ssl_cert_external = "*.domain.name"
#   ssl_cert_internal = "*.domain.name"
#   ssl_cert_admin    = "*.domain.name"
#   ssl_cert_manager  = "*.domain.name"
#   ssl_cert_portal   = "*.domain.name"

#   tags = {
#     Owner = "harpreet.paul@telus.name"
#     Team  = "EM"
#   }
# }

variable "access_key" {}
variable "secret_key" {}
variable "ec2_key_name" {}
variable "ee_bintray_auth" {}
variable "ee_license" {}

