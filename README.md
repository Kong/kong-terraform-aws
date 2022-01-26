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
  - HTTPS:8444 - Kong Admin API (Enterprise Edition only)
  - HTTPS:8445 - Kong Manager (Enterprise Edition only)
  - HTTPS:8446 - Kong Dev Portal GUI (Enterprise Edition only)
  - HTTPS:8447 - Kong Dev Portal API (Enterprise Edition only)
- Security groups granting least privilege access to resources
- An IAM instance profile for access to Kong specific SSM Parameter Store 
  metadata and secrets

Optionally, a Redis cluster can be provisioned for rate-limiting counters and
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

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | 3.72.0 |
| cloudinit | 2.2.0 |
| random | 3.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| kong\_external\_lb\_cw | ./cw/lb | n/a |
| kong\_internal\_lb\_cw | ./cw/lb | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_private\_subnet\_ids | Private subnet Ids | `list(string)` | n/a | yes |
| aws\_public\_subnet\_ids | Private subnet Ids | `list(string)` | n/a | yes |
| environment | Resource environment tag (i.e. dev, stage, prod) | `string` | n/a | yes |
| ssl\_cert\_admin\_domain | SSL certificate domain name for the Kong Admin API HTTPS listener | `string` | n/a | yes |
| ssl\_cert\_external\_arn | SSL certificate ARN for the external Kong Proxy HTTPS listener | `string` | n/a | yes |
| ssl\_cert\_internal\_arn | SSL certificate ARN for the internal Kong Proxy HTTPS listener | `string` | n/a | yes |
| vpc\_cidr\_block | VPC cidr block for the AWS account and region specified | `string` | n/a | yes |
| vpc\_id | VPC Id for the AWS account and region specified | `string` | n/a | yes |
| vpc\_name | VPC Name for the AWS account and region specified | `string` | n/a | yes |
| admin\_cidr\_blocks | Access to Kong Admin API (Enterprise Edition only) | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| admin\_user | The user name for Kong admin user | `string` | `"kong-admin"` | no |
| asg\_desired\_capacity | The number of instances that should be running in the group | `string` | `2` | no |
| asg\_health\_check\_grace\_period | Time in seconds after instance comes into service before checking health | `string` | `300` | no |
| asg\_max\_size | The maximum size of the auto scale group | `string` | `3` | no |
| asg\_min\_size | The minimum size of the auto scale group | `string` | `1` | no |
| bastion\_cidr\_blocks | Bastion hosts allowed access to PostgreSQL and Kong Admin | `list(string)` | <pre>[<br>  "127.0.0.1/32"<br>]</pre> | no |
| ce\_pkg | Url for Community Edition package matching the OS distro | `string` | `"https://download.konghq.com/gateway-2.x-ubuntu-focal/pool/all/k/kong/kong_2.3.3_amd64.deb"` | no |
| cloudwatch\_actions | List of cloudwatch actions for Alert/Ok | `list(string)` | `[]` | no |
| db\_backup\_retention\_period | The number of days to retain backups | `string` | `7` | no |
| db\_engine\_mode | Engine mode for Aurora | `string` | `"provisioned"` | no |
| db\_engine\_version | Database engine version | `string` | `"11.4"` | no |
| db\_family | Database parameter group family | `string` | `"postgres11"` | no |
| db\_final\_snapshot\_identifier | The final snapshot name of the RDS instance when it gets destroyed | `string` | `""` | no |
| db\_instance\_class | Database instance class | `string` | `"db.t2.micro"` | no |
| db\_instance\_count | Number of database instances (0 to leverage an existing db) | `string` | `1` | no |
| db\_kms\_key\_id | The ARN for the KMS encryption key. If creating an encrypted replica, set this to the destination KMS ARN. If db\_storage\_encrypted is set to true and kms\_key\_id is not specified the default KMS key created in your account will be used | `string` | `""` | no |
| db\_multi\_az | Boolean to specify if RDS is multi-AZ | `string` | `false` | no |
| db\_storage\_encrypted | Specifies whether the database instance is encrypted | `string` | `true` | no |
| db\_storage\_size | Size of the database storage in Gigabytes | `string` | `100` | no |
| db\_storage\_type | Type of the database storage | `string` | `"gp2"` | no |
| db\_subnets | Database instance subnet group name | `string` | `"db-subnets"` | no |
| db\_username | Database master username | `string` | `"root"` | no |
| deck\_version | Version of decK to install | `string` | `"1.5.1"` | no |
| default\_security\_group\_id | Id of the default VPC security group for EC2 access | `string` | `"default"` | no |
| default\_security\_group\_name | Name of the default VPC security group for EC2 access | `string` | `"default"` | no |
| deregistration\_delay | Seconds to wait before changing the state of a deregistering target from draining to unused | `string` | `300` | no |
| description | Resource description tag | `string` | `"Kong API Gateway"` | no |
| ec2\_ami | Map of Ubuntu Minimal AMIs by region | `map(string)` | <pre>{<br>  "us-east-1": "ami-04cc2b0ad9e30a9c8"<br>}</pre> | no |
| ec2\_instance\_type | EC2 instance type | `string` | `"t2.micro"` | no |
| ec2\_key\_name | AWS SSH Key | `string` | `""` | no |
| ec2\_root\_volume\_encryption | Should encrypt ec2 root volume | `bool` | `true` | no |
| ec2\_root\_volume\_size | Size of the root volume (in Gigabytes) | `string` | `8` | no |
| ec2\_root\_volume\_type | Type of the root volume (standard, gp2, or io) | `string` | `"gp2"` | no |
| ee\_bintray\_auth | Bintray authentication for the Enterprise Edition download (Format: username:apikey) | `string` | `"placeholder"` | no |
| ee\_license | Enterprise Edition license key (JSON format) | `string` | `"placeholder"` | no |
| ee\_pkg | Url for Enterprise Edition package matching the OS distro | `string` | `"https://download.konghq.com/gateway-2.x-ubuntu-focal/pool/all/k/kong-enterprise-edition/kong-enterprise-edition_2.3.3.0_all.deb"` | no |
| enable\_aurora | Boolean to enable Aurora | `string` | `"false"` | no |
| enable\_deletion\_protection | Boolean to enable delete protection on the ALB | `string` | `true` | no |
| enable\_ee | Boolean to enable Kong Enterprise Edition settings | `string` | `false` | no |
| enable\_external\_lb | Boolean to enable/create the external load balancer, exposing Kong to the Internet | `string` | `true` | no |
| enable\_internal\_lb | Boolean to enable/create the internal load balancer for the forward proxy | `string` | `true` | no |
| enable\_redis | Boolean to enable redis AWS resource | `string` | `false` | no |
| external\_cidr\_blocks | External ingress access to Kong Proxy via the load balancer | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| health\_check\_healthy\_threshold | Number of consecutives checks before a unhealthy target is considered healthy | `string` | `5` | no |
| health\_check\_interval | Seconds between health checks | `string` | `5` | no |
| health\_check\_matcher | HTTP Code(s) that result in a successful response from a target (comma delimited) | `string` | `200` | no |
| health\_check\_timeout | Seconds waited before a health check fails | `string` | `3` | no |
| health\_check\_unhealthy\_threshold | Number of consecutive checks before considering a target unhealthy | `string` | `2` | no |
| http\_4xx\_count | HTTP Code 4xx count threshhold | `string` | `50` | no |
| http\_5xx\_count | HTTP Code 5xx count threshhold | `string` | `50` | no |
| idle\_timeout | Seconds a connection can idle before being disconnected | `string` | `60` | no |
| internal\_http\_cidr\_blocks | Internal ingress access to Kong Proxy via the load balancer (HTTP) | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| internal\_https\_cidr\_blocks | Internal ingress access to Kong Proxy via the load balancer (HTTPS) | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| lb\_creation\_timeout | Timeout for creating load balancers | `string` | `"20m"` | no |
| lb\_deletion\_timeout | Timeout for deleting load balancers | `string` | `"20m"` | no |
| manager\_cidr\_blocks | Access to Kong Manager (Enterprise Edition only) | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| manager\_host | Hostname to access Kong Manager (Enterprise Edition only) | `string` | `"default"` | no |
| module\_dependencies | Variable to force the module to wait for other resources to finish creation | `any` | `null` | no |
| portal\_cidr\_blocks | Access to Portal (Enterprise Edition only) | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| portal\_host | Hostname to access Portal (Enterprise Edition only) | `string` | `"default"` | no |
| private\_subnets | Subnet tag on private subnets | `string` | `"private"` | no |
| public\_subnets | Subnet tag on public subnets for external load balancers | `string` | `"public"` | no |
| redis\_engine\_version | Redis engine version | `string` | `"5.0.5"` | no |
| redis\_family | Redis parameter group family | `string` | `"redis5.0"` | no |
| redis\_instance\_count | Number of redis nodes | `string` | `2` | no |
| redis\_instance\_type | Redis node instance type | `string` | `"cache.t2.small"` | no |
| redis\_subnets | Redis cluster subnet group name | `string` | `"cache-subnets"` | no |
| response\_time\_avg | Response time average threshhold in milliseconds | `string` | `1000` | no |
| service | Resource service tag | `string` | `"kong"` | no |
| ssl\_policy | SSL Policy for HTTPS Listeners | `string` | `"ELBSecurityPolicy-TLS-1-2-2017-01"` | no |
| subnet\_tag | Tag used on subnets to define Tier | `string` | `"Tier"` | no |
| tags | Tags to apply to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| admin\_password\_key\_name | The SSM key name for admin password for Kong |
| admin\_token | The admin token for Kong |
| autoscaling\_group | The autoscaling group |
| lb\_endpoint\_external | The external load balancer endpoint |
| lb\_endpoint\_internal | The internal load balancer endpoint |
| master\_password | The master password for Kong |
| rds\_endpoint | The endpoint for the Kong database |
| rds\_id | ID of the Kong database |
| rds\_password | The database password for Kong |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Examples

Example main.tf:

    provider "aws" {
      region  = "us-west-2"
      profile = "dev"
    }

    module "kong" {
      source = "faros-ai/kong/aws"
      version = "3.4.30"

      vpc                   = "my-vpc"
      environment           = "dev"
      ec2_key_name          = "my-key"
      ssl_cert_external_arn = aws_acm_certificate.cert.arn
      ssl_cert_internal_arn = aws_acm_certificate.cert.arn
      ssl_cert_admin_domain = "*.domain.name"

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
