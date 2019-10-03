output "db_instance_id" {
  value = aws_db_instance.postgresql.id
}

output "db_vpc_id" {
  value = module.postgres_network.vpc_id
}

output "db_subnet_ids" {
  value = module.postgres_network.db_subnet_ids
}

output "database_security_group_id" {
  value = module.postgres_network.security_group_id
}

output "vpc_network_acl_id" {
  value = module.postgres_network.network_acl_id
}

output "db_username_ssm_parameter" {
  value = module.postgres_credetials.username_ssm_name
}

output "db_password_ssm_parameter" {
  value = module.postgres_credetials.password_ssm_name
}

output "kms_arn" {
  value = module.postgres_credetials.kms_arn
}