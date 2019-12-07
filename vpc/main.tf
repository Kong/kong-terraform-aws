provider "aws" {
  region     = "ca-central-1"
  profile    = "dev"
  access_key = var.access_key
  secret_key = var.secret_key

}

variable "access_key" {}
variable "secret_key" {}
variable "ec2_key_name" {}
variable "ee_bintray_auth" {}
variable "ee_license" {}

