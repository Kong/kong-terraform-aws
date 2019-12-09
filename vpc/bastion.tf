module "bastion" {
  source        = "./bastion"
  subnet_id     = aws_subnet.public_subnet.id
  ssh_key       = var.ec2_key_name
  allowed_hosts = ["0.0.0.0/0"]
  internal_networks = [ var.vpc_cidr,
                        var.private_subnet1_cidr,
                        var.private_subnet2_cidr,
                        var.public_subnet_cidr,
                        var.public_subnet2_cidr]
  disk_size     = 10
  instance_type = "t2.micro"
  project       = "Kong AWS"
}
