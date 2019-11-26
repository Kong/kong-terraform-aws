output "rds_hostname" {
	value = aws_rds_cluster.kong.endpoint
}

output "master_password" {
	sensitive = true
	value     = random_string.master_password.result
}

output "admin_token" {
	sensitive = true
	value = random_string.admin_token.result
}

output "lb_endpoint_external" {
	value = aws_alb.external.dns_name
}

output "lb_endpoint_internal" {
	value = aws_alb.internal.dns_name
}
