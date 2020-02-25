# Network settings
variable "vpc" {
  description = "VPC Name for the AWS account and region specified"
  type        = string
}

variable "subnet_tag" {
  description = "Tag used on subnets to define Tier"
  type        = string

  default = "Tier"
}

variable "private_subnets" {
  description = "Subnet tag on private subnets"
  type        = string

  default = "private"
}

variable "public_subnets" {
  description = "Subnet tag on public subnets for external load balancers"
  type        = string

  default = "public"
}

variable "default_security_group" {
  description = "Name of the default VPC security group for EC2 access"
  type        = string

  default = "default"
}

# Access control
variable "bastion_cidr_blocks" {
  description = "Bastion hosts allowed access to PostgreSQL and Kong Admin"
  type        = list(string)

  default = [
    "127.0.0.1/32",
  ]
}

variable "external_cidr_blocks" {
  description = "External ingress access to Kong Proxy via the load balancer"
  type        = list(string)

  default = [
    "0.0.0.0/0",
  ]
}

variable "internal_http_cidr_blocks" {
  description = "Internal ingress access to Kong Proxy via the load balancer (HTTP)"
  type        = list(string)

  default = [
    "0.0.0.0/0",
  ]
}

variable "internal_https_cidr_blocks" {
  description = "Internal ingress access to Kong Proxy via the load balancer (HTTPS)"
  type        = list(string)

  default = [
    "0.0.0.0/0",
  ]
}

variable "admin_cidr_blocks" {
  description = "Access to Kong Admin API (Enterprise Edition only)"
  type        = list(string)

  default = [
    "0.0.0.0/0",
  ]
}

variable "manager_cidr_blocks" {
  description = "Access to Kong Manager (Enterprise Edition only)"
  type        = list(string)

  default = [
    "0.0.0.0/0",
  ]
}

variable "portal_cidr_blocks" {
  description = "Access to Portal (Enterprise Edition only)"
  type        = list(string)

  default = [
    "0.0.0.0/0",
  ]
}

variable "manager_host" {
  description = "Hostname to access Kong Manager (Enterprise Edition only)"
  type        = string

  default = "default"
}

variable "portal_host" {
  description = "Hostname to access Portal (Enterprise Edition only)"
  type        = string

  default = "default"
}

# Required tags
variable "description" {
  description = "Resource description tag"
  type        = string

  default = "Kong API Gateway"
}

variable "environment" {
  description = "Resource environment tag (i.e. dev, stage, prod)"
  type        = string
}

variable "service" {
  description = "Resource service tag"
  type        = string

  default = "kong"
}

# Additional tags
variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)

  default = {}
}

# Enterprise Edition
variable "enable_ee" {
  description = "Boolean to enable Kong Enterprise Edition settings"
  type        = string

  default = false
}

variable "ee_bintray_auth" {
  description = "Bintray authentication for the Enterprise Edition download (Format: username:apikey)"
  type        = string

  default = "placeholder"
}

variable "ee_license" {
  description = "Enterprise Edition license key (JSON format)"
  type        = string

  default = "placeholder"
}

# EC2 settings

# https://wiki.ubuntu.com/Minimal
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
  }
}

variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string

  default = "t2.micro"
}

variable "ec2_root_volume_size" {
  description = "Size of the root volume (in Gigabytes)"
  type        = string

  default = 8
}

variable "ec2_root_volume_type" {
  description = "Type of the root volume (standard, gp2, or io)"
  type        = string

  default = "gp2"
}

variable "ec2_key_name" {
  description = "AWS SSH Key"
  type        = string
}

variable "asg_max_size" {
  description = "The maximum size of the auto scale group"
  type        = string

  default = 3
}

variable "asg_min_size" {
  description = "The minimum size of the auto scale group"
  type        = string

  default = 1
}

variable "asg_desired_capacity" {
  description = "The number of instances that should be running in the group"
  type        = string

  default = 2
}

variable "asg_health_check_grace_period" {
  description = "Time in seconds after instance comes into service before checking health"
  type        = string

  # Terraform default is 300
  default = 300
}

# Kong packages
variable "ee_pkg" {
  description = "Filename of the Enterprise Edition package"
  type        = string

  default = "kong-enterprise-edition-1.3.0.1.bionic.all.deb "
}

variable "ce_pkg" {
  description = "Filename of the Community Edition package"
  type        = string

  default = "kong-1.5.0.bionic.amd64.deb"
}

# Load Balancer settings
variable "enable_external_lb" {
  description = "Boolean to enable/create the external load balancer, exposing Kong to the Internet"
  type        = string

  default = true
}

variable "enable_internal_lb" {
  description = "Boolean to enable/create the internal load balancer for the forward proxy"
  type        = string

  default = true
}

variable "deregistration_delay" {
  description = "Seconds to wait before changing the state of a deregistering target from draining to unused"
  type        = string

  # Terraform default is 300
  default = 300
}

variable "enable_deletion_protection" {
  description = "Boolean to enable delete protection on the ALB"
  type        = string

  # Terraform default is false
  default = true
}

variable "health_check_healthy_threshold" {
  description = "Number of consecutives checks before a unhealthy target is considered healthy"
  type        = string

  # Terraform default is 5
  default = 5
}

variable "health_check_interval" {
  description = "Seconds between health checks"
  type        = string

  # Terraform default is 30
  default = 5
}

variable "health_check_matcher" {
  description = "HTTP Code(s) that result in a successful response from a target (comma delimited)"
  type        = string

  default = 200
}

variable "health_check_timeout" {
  description = "Seconds waited before a health check fails"
  type        = string

  # Terraform default is 5
  default = 3
}

variable "health_check_unhealthy_threshold" {
  description = "Number of consecutive checks before considering a target unhealthy"
  type        = string

  # Terraform default is 2
  default = 2
}

variable "idle_timeout" {
  description = "Seconds a connection can idle before being disconnected"
  type        = string

  # Terraform default is 60
  default = 60
}

variable "ssl_cert_external" {
  description = "SSL certificate domain name for the external Kong Proxy HTTPS listener"
  type        = string
}

variable "ssl_cert_internal" {
  description = "SSL certificate domain name for the internal Kong Proxy HTTPS listener"
  type        = string
}

variable "ssl_cert_admin" {
  description = "SSL certificate domain name for the Kong Admin API HTTPS listener"
  type        = string
}

variable "ssl_cert_manager" {
  description = "SSL certificate domain name for the Kong Manager HTTPS listener"
  type        = string
}

variable "ssl_cert_portal" {
  description = "SSL certificate domain name for the Dev Portal listener"
  type        = string
}

variable "ssl_policy" {
  description = "SSL Policy for HTTPS Listeners"
  type        = string

  default = "ELBSecurityPolicy-TLS-1-2-2017-01"
}

# Cloudwatch alarms
variable "cloudwatch_actions" {
  description = "List of cloudwatch actions for Alert/Ok"
  type        = list(string)

  default = []
}

variable "http_4xx_count" {
  description = "HTTP Code 4xx count threshhold"
  type        = string

  default = 50
}

variable "http_5xx_count" {
  description = "HTTP Code 5xx count threshhold"
  type        = string

  default = 50
}

# Datastore settings
variable "enable_aurora" {
  description = "Boolean to enable Aurora"
  type        = string

  default = "false"
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string

  default = "11.4"
}

variable "db_engine_mode" {
  description = "Engine mode for Aurora"
  type        = string

  default = "provisioned"
}

variable "db_family" {
  description = "Database parameter group family"
  type        = string

  default = "postgres11"
}

variable "db_instance_class" {
  description = "Database instance class"
  type        = string

  default = "db.t2.micro"
}

variable "db_instance_count" {
  description = "Number of database instances (0 to leverage an existing db)"
  type        = string

  default = 1
}

variable "db_storage_size" {
  description = "Size of the database storage in Gigabytes"
  type        = string

  # 100 is the recommended AWS minimum
  default = 100
}

variable "db_storage_type" {
  description = "Type of the database storage"
  type        = string

  default = "gp2"
}

variable "db_username" {
  description = "Database master username"
  type        = string

  default = "root"
}

variable "db_subnets" {
  description = "Database instance subnet group name"
  type        = string

  default = "db-subnets"
}

variable "db_multi_az" {
  description = "Boolean to specify if RDS is multi-AZ"
  type        = string

  default = false
}

variable "db_backup_retention_period" {
  description = "The number of days to retain backups"
  type        = string

  default = 7
}

# Redis settings (for rate_limiting only)
variable "enable_redis" {
  description = "Boolean to enable redis AWS resource"
  type        = string

  default = false
}

variable "redis_instance_type" {
  description = "Redis node instance type"
  type        = string

  default = "cache.t2.small"
}

variable "redis_engine_version" {
  description = "Redis engine version"
  type        = string

  default = "5.0.5"
}

variable "redis_family" {
  description = "Redis parameter group family"
  type        = string

  default = "redis5.0"
}

variable "redis_instance_count" {
  description = "Number of redis nodes"
  type        = string

  default = 2
}

variable "redis_subnets" {
  description = "Redis cluster subnet group name"
  type        = string

  default = "cache-subnets"
}

variable "deck_version" {
  description = "Version of decK to install"
  type        = string

  default = "1.0.0"
}

variable "db_final_snapshot_identifier" {
  description = "The final snapshot name of the RDS instance when it gets destroyed"
  type        = string
  default     = ""
}
