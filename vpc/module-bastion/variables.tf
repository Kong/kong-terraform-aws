variable "project" {
  description = "Project tag."
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in."
}

variable "ssh_key" {
  description = "The key name of the Key Pair to use for the instance."
}

variable "allowed_hosts" {
  description = "CIDR blocks of trusted networks"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "instance_type" {
  description = "The type of instance to start."
  default     = "t3.micro"
}

variable "disk_size" {
  description = "The size of the root volume in gigabytes."
  default     = 10
}

variable "internal_networks" {
  type        = list(string)
  description = "Internal network CIDR blocks."
}

data "aws_ami" "centos" {
  most_recent = true

  filter {
    name   = "product-code"
    values = ["aw0evgkw8e5c1q413zgy5pjce"]
  }

  owners = ["aws-marketplace"]
}

variable "ec2_ami" {
  description = "Map of Ubuntu Minimal AMIs by region"
  type        = map(string)

  default = {
    us-east-1    = "ami-7029320f"
    us-east-2    = "ami-0350efe0754b8e179"
    us-west-1    = "ami-657f9006"
    us-west-2    = "ami-59694f21"
    eu-central-1 = "ami-19b2bcf2"
    eu-west-1    = "ami-0395f5f72b8516ef9"
    ca-central-1 = "ami-0972a0d3135cf1fc0"
  }
}

data "aws_subnet" "public" {
  id = local.subnet_id
}

data "aws_region" "current" {}

locals {
  vpc_id        = data.aws_subnet.public.vpc_id
  project       = var.project
  #ami_id        = data.aws_ami.centos.id
  ami_id        = var.ec2_ami[data.aws_region.current.name]
  disk_size     = var.disk_size
  subnet_id     = var.subnet_id
  ssh_key       = var.ssh_key
  instance_type = var.instance_type
}

