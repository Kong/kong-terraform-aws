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

## Variables

<table>
<tr><th>Name</th><th>Description</th><th>Type</th><th>Default</th> <th>Required</th></tr>
<tr>
<td>admin_cidr_blocks</td>
<td>Access to Kong Admin API (Enterprise Edition only)</td>
<td>

`list(string)`</td>
<td>

```json
[
  "0.0.0.0/0"
]
```
</td>
<td>no</td>
</tr>
<tr>
<td>asg_desired_capacity</td>
<td>The number of instances that should be running in the group</td>
<td>

`string`</td>
<td>

`2`</td>
<td>no</td>
</tr>
<tr>
<td>asg_health_check_grace_period</td>
<td>Time in seconds after instance comes into service before checking health</td>
<td>

`string`</td>
<td>

`300`</td>
<td>no</td>
</tr>
<tr>
<td>asg_max_size</td>
<td>The maximum size of the auto scale group</td>
<td>

`string`</td>
<td>

`3`</td>
<td>no</td>
</tr>
<tr>
<td>asg_min_size</td>
<td>The minimum size of the auto scale group</td>
<td>

`string`</td>
<td>

`1`</td>
<td>no</td>
</tr>
<tr>
<td>bastion_cidr_blocks</td>
<td>Bastion hosts allowed access to PostgreSQL and Kong Admin</td>
<td>

`list(string)`</td>
<td>

```json
[
  "127.0.0.1/32"
]
```
</td>
<td>no</td>
</tr>
<tr>
<td>ce_pkg</td>
<td>Filename of the Community Edition package</td>
<td>

`string`</td>
<td>

`"kong-1.3.0.bionic.amd64.deb"`</td>
<td>no</td>
</tr>
<tr>
<td>cloudwatch_actions</td>
<td>List of cloudwatch actions for Alert/Ok</td>
<td>

`list(string)`</td>
<td>

`[]`</td>
<td>no</td>
</tr>
<tr>
<td>db_backup_retention_period</td>
<td>The number of days to retain backups</td>
<td>

`string`</td>
<td>

`7`</td>
<td>no</td>
</tr>
<tr>
<td>db_engine_mode</td>
<td>Engine mode for Aurora</td>
<td>

`string`</td>
<td>

`"provisioned"`</td>
<td>no</td>
</tr>
<tr>
<td>db_engine_version</td>
<td>Database engine version</td>
<td>

`string`</td>
<td>

`"11.4"`</td>
<td>no</td>
</tr>
<tr>
<td>db_family</td>
<td>Database parameter group family</td>
<td>

`string`</td>
<td>

`"postgres11"`</td>
<td>no</td>
</tr>
<tr>
<td>db_instance_class</td>
<td>Database instance class</td>
<td>

`string`</td>
<td>

`"db.t2.micro"`</td>
<td>no</td>
</tr>
<tr>
<td>db_instance_count</td>
<td>Number of database instances (0 to leverage an existing db)</td>
<td>

`string`</td>
<td>

`1`</td>
<td>no</td>
</tr>
<tr>
<td>db_multi_az</td>
<td>Boolean to specify if RDS is multi-AZ</td>
<td>

`string`</td>
<td>

`false`</td>
<td>no</td>
</tr>
<tr>
<td>db_storage_size</td>
<td>Size of the database storage in Gigabytes</td>
<td>

`string`</td>
<td>

`20`</td>
<td>no</td>
</tr>
<tr>
<td>db_storage_type</td>
<td>Type of the database storage</td>
<td>

`string`</td>
<td>

`"gp2"`</td>
<td>no</td>
</tr>
<tr>
<td>db_subnets</td>
<td>Database instance subnet group name</td>
<td>

`string`</td>
<td>

`"db-subnets"`</td>
<td>no</td>
</tr>
<tr>
<td>db_username</td>
<td>Database master username</td>
<td>

`string`</td>
<td>

`"root"`</td>
<td>no</td>
</tr>
<tr>
<td>deck_version</td>
<td>Version of decK to install</td>
<td>

`string`</td>
<td>

`"0.5.2"`</td>
<td>no</td>
</tr>
<tr>
<td>default_security_group</td>
<td>Name of the default VPC security group for EC2 access</td>
<td>

`string`</td>
<td>

`"default"`</td>
<td>no</td>
</tr>
<tr>
<td>deregistration_delay</td>
<td>Seconds to wait before changing the state of a deregistering target from draining to unused</td>
<td>

`string`</td>
<td>

`300`</td>
<td>no</td>
</tr>
<tr>
<td>description</td>
<td>Resource description tag</td>
<td>

`string`</td>
<td>

`"Kong API Gateway"`</td>
<td>no</td>
</tr>
<tr>
<td>ec2_ami</td>
<td>Map of Ubuntu Minimal AMIs by region</td>
<td>

`map(string)`</td>
<td>

```json
{
  "us-east-1": "ami-7029320f",
  "us-east-2": "ami-0350efe0754b8e179",
  "us-west-1": "ami-657f9006",
  "us-west-2": "ami-59694f21"
}
```
</td>
<td>no</td>
</tr>
<tr>
<td>ec2_instance_type</td>
<td>EC2 instance type</td>
<td>

`string`</td>
<td>

`"t2.micro"`</td>
<td>no</td>
</tr>
<tr>
<td>ec2_key_name</td>
<td>AWS SSH Key</td>
<td>

`string`</td>
<td>

n/a</td>
<td>yes</td>
</tr>
<tr>
<td>ec2_root_volume_size</td>
<td>Size of the root volume (in Gigabytes)</td>
<td>

`string`</td>
<td>

`8`</td>
<td>no</td>
</tr>
<tr>
<td>ec2_root_volume_type</td>
<td>Type of the root volume (standard, gp2, or io)</td>
<td>

`string`</td>
<td>

`"gp2"`</td>
<td>no</td>
</tr>
<tr>
<td>ee_bintray_auth</td>
<td>Bintray authentication for the Enterprise Edition download (Format: username:apikey)</td>
<td>

`string`</td>
<td>

`"placeholder"`</td>
<td>no</td>
</tr>
<tr>
<td>ee_license</td>
<td>Enterprise Edition license key (JSON format)</td>
<td>

`string`</td>
<td>

`"placeholder"`</td>
<td>no</td>
</tr>
<tr>
<td>ee_pkg</td>
<td>Filename of the Enterprise Edition package</td>
<td>

`string`</td>
<td>

`"kong-enterprise-edition-0.36-2.bionic.all.deb"`</td>
<td>no</td>
</tr>
<tr>
<td>enable_aurora</td>
<td>Boolean to enable Aurora</td>
<td>

`string`</td>
<td>

`"false"`</td>
<td>no</td>
</tr>
<tr>
<td>enable_deletion_protection</td>
<td>Boolean to enable delete protection on the ALB</td>
<td>

`string`</td>
<td>

`true`</td>
<td>no</td>
</tr>
<tr>
<td>enable_ee</td>
<td>Boolean to enable Kong Enterprise Edition settings</td>
<td>

`string`</td>
<td>

`false`</td>
<td>no</td>
</tr>
<tr>
<td>enable_external_lb</td>
<td>Boolean to enable/create the external load balancer, exposing Kong to the Internet</td>
<td>

`string`</td>
<td>

`true`</td>
<td>no</td>
</tr>
<tr>
<td>enable_internal_lb</td>
<td>Boolean to enable/create the internal load balancer for the forward proxy</td>
<td>

`string`</td>
<td>

`true`</td>
<td>no</td>
</tr>
<tr>
<td>enable_redis</td>
<td>Boolean to enable redis AWS resource</td>
<td>

`string`</td>
<td>

`false`</td>
<td>no</td>
</tr>
<tr>
<td>environment</td>
<td>Resource environment tag (i.e. dev, stage, prod)</td>
<td>

`string`</td>
<td>

n/a</td>
<td>yes</td>
</tr>
<tr>
<td>external_cidr_blocks</td>
<td>External ingress access to Kong Proxy via the load balancer</td>
<td>

`list(string)`</td>
<td>

```json
[
  "0.0.0.0/0"
]
```
</td>
<td>no</td>
</tr>
<tr>
<td>health_check_healthy_threshold</td>
<td>Number of consecutives checks before a unhealthy target is considered healthy</td>
<td>

`string`</td>
<td>

`5`</td>
<td>no</td>
</tr>
<tr>
<td>health_check_interval</td>
<td>Seconds between health checks</td>
<td>

`string`</td>
<td>

`5`</td>
<td>no</td>
</tr>
<tr>
<td>health_check_matcher</td>
<td>HTTP Code(s) that result in a successful response from a target (comma delimited)</td>
<td>

`string`</td>
<td>

`200`</td>
<td>no</td>
</tr>
<tr>
<td>health_check_timeout</td>
<td>Seconds waited before a health check fails</td>
<td>

`string`</td>
<td>

`3`</td>
<td>no</td>
</tr>
<tr>
<td>health_check_unhealthy_threshold</td>
<td>Number of consecutive checks before considering a target unhealthy</td>
<td>

`string`</td>
<td>

`2`</td>
<td>no</td>
</tr>
<tr>
<td>http_4xx_count</td>
<td>HTTP Code 4xx count threshhold</td>
<td>

`string`</td>
<td>

`50`</td>
<td>no</td>
</tr>
<tr>
<td>http_5xx_count</td>
<td>HTTP Code 5xx count threshhold</td>
<td>

`string`</td>
<td>

`50`</td>
<td>no</td>
</tr>
<tr>
<td>idle_timeout</td>
<td>Seconds a connection can idle before being disconnected</td>
<td>

`string`</td>
<td>

`60`</td>
<td>no</td>
</tr>
<tr>
<td>internal_http_cidr_blocks</td>
<td>Internal ingress access to Kong Proxy via the load balancer (HTTP)</td>
<td>

`list(string)`</td>
<td>

```json
[
  "0.0.0.0/0"
]
```
</td>
<td>no</td>
</tr>
<tr>
<td>internal_https_cidr_blocks</td>
<td>Internal ingress access to Kong Proxy via the load balancer (HTTPS)</td>
<td>

`list(string)`</td>
<td>

```json
[
  "0.0.0.0/0"
]
```
</td>
<td>no</td>
</tr>
<tr>
<td>manager_cidr_blocks</td>
<td>Access to Kong Manager (Enterprise Edition only)</td>
<td>

`list(string)`</td>
<td>

```json
[
  "0.0.0.0/0"
]
```
</td>
<td>no</td>
</tr>
<tr>
<td>manager_host</td>
<td>Hostname to access Kong Manager (Enterprise Edition only)</td>
<td>

`string`
</td>
<td>
  
`"default`"
</td>
<td>no</td>
</tr>
<tr>
<td>portal_cidr_blocks</td>
<td>Access to Portal (Enterprise Edition only)</td>
<td>

`list(string)`</td>
<td>

```json
[
  "0.0.0.0/0"
]
```
</td>
<td>no</td>
</tr>
<tr>
<td>portal_host</td>
<td>Hostname to access Portal (Enterprise Edition only)</td>
<td>

`string`
</td>
<td>

`"default`"
</td>
<td>no</td>
</tr>
<tr>
<td>private_subnets</td>
<td>Subnet tag on private subnets</td>
<td>

`string`</td>
<td>

`"private"`</td>
<td>no</td>
</tr>
<tr>
<td>public_subnets</td>
<td>Subnet tag on public subnets for external load balancers</td>
<td>

`string`</td>
<td>

`"public"`</td>
<td>no</td>
</tr>
<tr>
<td>redis_engine_version</td>
<td>Redis engine version</td>
<td>

`string`</td>
<td>

`"5.0.5"`</td>
<td>no</td>
</tr>
<tr>
<td>redis_family</td>
<td>Redis parameter group family</td>
<td>

`string`</td>
<td>

`"redis5.0"`</td>
<td>no</td>
</tr>
<tr>
<td>redis_instance_count</td>
<td>Number of redis nodes</td>
<td>

`string`</td>
<td>

`2`</td>
<td>no</td>
</tr>
<tr>
<td>redis_instance_type</td>
<td>Redis node instance type</td>
<td>

`string`</td>
<td>

`"cache.t2.small"`</td>
<td>no</td>
</tr>
<tr>
<td>redis_subnets</td>
<td>Redis cluster subnet group name</td>
<td>

`string`</td>
<td>

`"cache-subnets"`</td>
<td>no</td>
</tr>
<tr>
<td>service</td>
<td>Resource service tag</td>
<td>

`string`</td>
<td>

`"kong"`</td>
<td>no</td>
</tr>
<tr>
<td>ssl_cert_admin</td>
<td>SSL certificate domain name for the Kong Admin API HTTPS listener</td>
<td>

`string`</td>
<td>

n/a</td>
<td>yes</td>
</tr>
<tr>
<td>ssl_cert_external</td>
<td>SSL certificate domain name for the external Kong Proxy HTTPS listener</td>
<td>

`string`</td>
<td>

n/a</td>
<td>yes</td>
</tr>
<tr>
<td>ssl_cert_internal</td>
<td>SSL certificate domain name for the internal Kong Proxy HTTPS listener</td>
<td>

`string`</td>
<td>

n/a</td>
<td>yes</td>
</tr>
<tr>
<td>ssl_cert_manager</td>
<td>SSL certificate domain name for the Kong Manager HTTPS listener</td>
<td>

`string`</td>
<td>

n/a</td>
<td>yes</td>
</tr>
<tr>
<td>ssl_cert_portal</td>
<td>SSL certificate domain name for the Dev Portal listener</td>
<td>

`string`</td>
<td>

n/a</td>
<td>yes</td>
</tr>
<tr>
<td>ssl_policy</td>
<td>SSL Policy for HTTPS Listeners</td>
<td>

`string`</td>
<td>

`"ELBSecurityPolicy-TLS-1-2-2017-01"`</td>
<td>no</td>
</tr>
<tr>
<td>subnet_tag</td>
<td>Tag used on subnets to define Tier</td>
<td>

`string`</td>
<td>

`"Tier"`</td>
<td>no</td>
</tr>
<tr>
<td>tags</td>
<td>Tags to apply to resources</td>
<td>

`map`</td>
<td>

`{}`</td>
<td>no</td>
</tr>
<tr>
<td>vpc</td>
<td>VPC Name for the AWS account and region specified</td>
<td>

`string`</td>
<td>

n/a</td>
<td>yes</td>
</tr>
<tr>
<td>db_final_snapshot_identifier</td>
<td>If specified a final snapshot will be made of the RDS instance. If left blank, the finalsnapshot will be skipped</td>
<td>

`string`</td>
<td>

""</td>
<td>no</td>
</tr>
</table>

Note: Admin, manager, and portal are Enterprise features. While the SSL
certificate needs to be defined, it can be the same as the external and/or
internal; however, no resources associated with it are created unless enabled.

## Outputs

| Name | Description |
|------|-------------|
| admin\_token | The admin token for Kong |
| lb\_endpoint\_external | The external load balancer endpoint |
| lb\_endpoint\_internal | The internal load balancer endpoint |
| master\_password | The master password for Kong |
| rds\_endpoint | The endpoint for the Kong database |
| rds\_password | The database password for Kong |

## Examples

Example main.tf:

    provider "aws" {
      region  = "us-west-2"
      profile = "dev"
    }

    module "kong" {
      source = "github.com/kong/kong-terraform-aws?ref=v3.3"

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
