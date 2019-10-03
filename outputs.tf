output "db_instance_id" {
  value = aws_db_instance.postgresql.id
}

output "db_vpc_id" {
  value = module.postgres_network.vpc_id
}

output "public_subnet_id" {
  value = module.postgres_network.public_subnet_id
}

output "private_subnet_id" {
  value = module.postgres_network.private_subnet_id
}

output "database_security_group_id" {
  value = module.postgres_network.security_group_id
}

output "db_username_ssm_parameter" {
  value = module.postgres_credetials.username_ssm_name
}

output "db_password_ssm_parameter" {
  value = module.postgres_credetials.password_ssm_name
}

output "kms_alias_arn" {
  value = module.postgres_credetials.kms_arn
}