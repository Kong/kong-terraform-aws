variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "private_subnet1_cidr" {
  description = "CIDR for the Private Subnet 1"
  default     = "10.0.1.0/26"
}

variable "private_subnet2_cidr" {
  description = "CIDR for the Private Subnet 2"
  default     = "10.0.5.0/26"
}

variable "public_subnet_cidr" {
  description = "CIDR for the Public Subnet 1"
  default     = "10.0.2.0/26"
}

variable "public_subnet2_cidr" {
  description = "CIDR for the Public Subnet 2"
  default     = "10.0.3.0/26"
}

variable "db_subnet1_cidr" {
  description = "CIDR for the DB Subnet 1"
  default     = "10.0.7.0/26"
}

variable "db_subnet2_cidr" {
  description = "CIDR for the DB Subnet 2"
  default     = "10.0.6.0/26"
}

variable "cache_subnet_cidr" {
  description = "CIDR for the Cache Subnet"
  default     = "10.0.4.0/26"
}

variable "instanceTenancy" {
  default = "default"
}

variable "dnsSupport" {
  default = true
}

variable "dnsHostNames" {
  default = true
}

variable "mapPublicIP" {
  default = true
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

variable "availabilityZoneA" {
  default = "ca-central-1a"
}
variable "availabilityZoneB" {
  default = "ca-central-1b"
}

### define here Telus IP range
variable "vpc_ingress_cidr" {
  default = "0.0.0.0/0"
}

variable "vpc_egress_cidr" {
  default = "0.0.0.0/0"
}