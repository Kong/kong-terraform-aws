# Kong Cluster Terraform Module for AWS

[Kong API Gateway](https://konghq.com/) is an API gateway microservices
management layer. Both Kong and Enterprise Edition are supported.

By default, the following resources will be provisioned:

- RDS PostgreSQL database for Kong's configuration store
- An Auto Scaling Group (ASG) and EC2 instances running Kong (Kong nodes)
- An external load balancer (HTTPS only)
  - HTTPS:443 - Kong Proxy
- An internal load balancer (HTTP and HTTPS)
  - HTTP:80 - Kong Proxy
  - HTTPS:443 - Kong Proxy
  - HTTPS:8444 - Kong Admin API
  - HTTPS:8445 - Kong Manager (Enterprise Edition only)
  - HTTPS:8446 - Kong Dev Portal GUI (Enterprise Edition only)
  - HTTPS:8447 - Kong Dev Portal API (Enterprise Edition only)
- Security groups granting least privilege access to resources
- An IAM instance profile for access to Kong specific SSM Parameter Store 
  metadata and secrets

Optionally, a redis cluster can be provisioned for rate-limiting counters and
caching, and most default resources can be disabled.  See variables.tf for a
complete list and description of tunables. 

The Kong nodes are based on [Minimal Ubuntu](https://wiki.ubuntu.com/Minimal).
Using cloud-init, the following is provisioned on top of the AMI:

- A kong service user
- Minimal set of dependencies and debugging tools
- decK for Kong declarative configuration management
- Kong, running under runit process supervision
- Log rotation of Kong log files

Prerequisites:

- An AWS VPC
- Private and public subnets tagged with a subnet_tag (default = 'Tier' tag)
- Database subnet group
- Cache subnet group (if enabling Redis)
- An SSH Key
- An SSL managed certificate to associate with HTTPS load balancers

Required variables:

    vpc                  VPC name for the AWS account and region specified
    environment          Resource environment tag (i.e. dev, stage, prod)
    ec2_key_name         AWS SSH Key
    ssl_cert_external    SSL certificate domain name for the external Kong Proxy HTTPS listener 
    ssl_cert_internal    SSL certificate domain name for the internal Kong Proxy HTTPS listener
    ssl_cert_admin       SSL certificate domain name for the Kong Admin API HTTPS listener
    ssl_cert_manager     SSL certificate domain name for the Kong Manager HTTPS listener
    ssl_cert_portal      SSL certificate domain name for the Dev Portal listener

Note: Admin, manager, and portal are Enterprise features. While the SSL
certificate needs to be defined, it can be the same as the external and/or
internal; however, no resources associated with it are created unless enabled.

Example main.tf:

    provider "aws" {
      region  = "us-west-2"
      profile = "dev"
    }

    module "kong" {
      source = "github.com/kong/kong-terraform-aws?ref=v3.1"

      vpc                   = "my-vpc"
      environment           = "dev"
      ec2_key_name          = "my-key"
      ssl_cert_external     = "*.domain.name"
      ssl_cert_internal     = "*.domain.name"
      ssl_cert_admin        = "*.domain.name"
      ssl_cert_manager      = "*.domain.name"
      ssl_cert_portal       = "*.domain.name"

      tags = {
         Owner = "devops@domain.name"
         Team = "DevOps"
      }
    }

Create the resources in AWS:

    terraform init
    terraform plan -out kong.plan
    terraform apply kong.plan

If installing Enterprise Edition, while resources are being provisioned login
to the AWS console and navigate to:

    Systems Manager -> Parameter Store

Update the license key by editing the parameter (default value is "placeholder"):
 
    /[service]/[environment]/ee/license

Update the Bintray authentication paramater (default value is "placeholder",
format is "username:apikey")" for downloads:

    /[service]/[environment]/ee/bintray-auth

Alternatively, if your terraform files and state are secure, you can pass them 
as variables to the module for a completely hands-off installation.

To login to the EC2 instance(s):

    ssh -i [/path/to/key/specified/in/ec2_key_name] ubuntu@[ec2-instance]

You are now ready to manage APIs!
