output "security_group_id" {
  value = aws_security_group.postgres_security_group.id
}

output "network_acl_id" {
  value = aws_network_acl.vpc_security_acl.id
}

output "subnet_group" {
  value = aws_db_subnet_group.postgres_subnet_group.id
}

output "vpc_id" {
  value = aws_vpc.postgres_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}