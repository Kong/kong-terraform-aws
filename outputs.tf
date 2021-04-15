output "rds_id" {
  value       = aws_db_instance.kong.*.id
  description = "ID of the Kong database"
}

output "rds_endpoint" {
  value       = coalesce(aws_rds_cluster.kong.*.endpoint)
  description = "The endpoint for the Kong database"
}

output "rds_password" {
  sensitive   = true
  value       = random_string.db_password.result
  description = "The database password for Kong"
}

output "master_password" {
  sensitive   = true
  value       = random_string.master_password.result
  description = "The master password for Kong"
}

output "admin_password_key_name" {
  value       = aws_ssm_parameter.admin-password.name
  description = "The SSM key name for admin password for Kong"
}

output "admin_token" {
  sensitive   = true
  value       = random_string.admin_token.result
  description = "The admin token for Kong"
}

output "lb_endpoint_external" {
  value       = coalesce(aws_lb.external.*.dns_name)
  description = "The external load balancer endpoint"
}

output "lb_endpoint_internal" {
  value       = coalesce(aws_lb.internal.*.dns_name)
  description = "The internal load balancer endpoint"
}

output "autoscaling_group" {
  value       = coalesce(aws_autoscaling_group.kong.*.name)
  description = "The autoscaling group"
}