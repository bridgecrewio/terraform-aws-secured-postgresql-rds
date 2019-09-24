output "security_group_id" {
  value = aws_security_group.postgres_security_group.id
}

output "subnet_group" {
  value = aws_db_subnet_group.postgres_subnet_group.id
}