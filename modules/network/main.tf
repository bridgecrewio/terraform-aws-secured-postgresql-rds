data "aws_availability_zones" "available_availability_zones" {
  state = "available"
}

data "aws_region" "current_region" {}

locals {
  allow_connection_to_office = var.office_cidr_range != "0.0.0.0/32"
  ip_range_as_list           = split(".", var.vpc_cidr_block)
}

resource "aws_vpc" "postgres_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name           = "${var.resource_prefix} vpc"
    Environment    = var.environment
    TerraformStack = var.resource_prefix
  }
}

resource "aws_subnet" "db_subnets" {
  count             = 3
  vpc_id            = aws_vpc.postgres_vpc.id
  cidr_block        = format("%s.%s.%s.0/24", local.ip_range_as_list[0], local.ip_range_as_list[1], count.index)
  availability_zone = data.aws_availability_zones.available_availability_zones.names[count.index]
  tags = {
    Name           = "${var.resource_prefix} subnet #${count.index + 1}"
    Environment    = var.environment
    TerraformStack = var.resource_prefix
  }
}

resource "aws_db_subnet_group" "postgres_subnet_group" {
  name       = "${var.resource_prefix}subnet_group"
  subnet_ids = aws_subnet.db_subnets.*.id

  tags = {
    Name           = "${var.resource_prefix} subnet group"
    Environment    = var.environment
    TerraformStack = var.resource_prefix
  }
}

resource "aws_security_group" "postgres_security_group" {
  vpc_id      = aws_vpc.postgres_vpc.id
  name        = "${var.resource_prefix} security group"
  description = "postgres security group"
  ingress {
    cidr_blocks = [var.vpc_cidr_block]
    from_port   = var.database_port
    to_port     = var.database_port
    protocol    = "tcp"
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name           = "${var.resource_prefix}-security-group"
    Environment    = var.environment
    TerraformStack = var.resource_prefix
  }
}

resource "aws_security_group_rule" "offic_security_group_rule_postgres" {
  count             = local.allow_connection_to_office ? 1 : 0
  from_port         = var.database_port
  protocol          = "tcp"
  security_group_id = aws_security_group.postgres_security_group.id
  to_port           = var.database_port
  type              = "ingress"
  cidr_blocks       = [var.office_cidr_range]
}

resource "aws_security_group_rule" "office_security_group_rule_ssh" {
  count             = local.allow_connection_to_office ? 1 : 0
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.postgres_security_group.id
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = [var.office_cidr_range]
}

# Create the Internet Gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.postgres_vpc.id
  tags = {
    Name           = var.resource_prefix
    TerraformStack = var.resource_prefix
  }
}

# Create the Internet Access
resource "aws_route" "routing_table_internet_access" {
  route_table_id         = aws_route_table.postgres_vpc_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

# create VPC Network access control list
resource "aws_network_acl" "vpc_security_acl" {
  vpc_id     = aws_vpc.postgres_vpc.id
  subnet_ids = aws_subnet.db_subnets.*.id

  # allow port "${var.databse_port}"
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.vpc_cidr_block
    from_port  = var.database_port
    to_port    = var.database_port
  }

  # allow HTTPS traffic
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  # allow ingress ephemeral ports
  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  # allow egress ephemeral ports
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.vpc_cidr_block
    from_port  = var.database_port
    to_port    = var.database_port
  }

  egress {
    action     = "allow"
    from_port  = 0
    protocol   = "all"
    rule_no    = 200
    to_port    = 0
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    Name           = "${var.resource_prefix} vpc ACL"
    Environment    = var.environment
    TerraformStack = var.resource_prefix
  }
}

resource "aws_network_acl_rule" "office_network_acl_db_port_rule" {
  count          = local.allow_connection_to_office ? 1 : 0
  from_port      = var.database_port
  protocol       = "tcp"
  to_port        = var.database_port
  egress         = false
  network_acl_id = aws_network_acl.vpc_security_acl.id
  rule_action    = "allow"
  rule_number    = 98
  cidr_block     = var.office_cidr_range
}

resource "aws_network_acl_rule" "office_network_acl_ssh_rule" {
  count          = local.allow_connection_to_office ? 1 : 0
  from_port      = 22
  protocol       = "tcp"
  to_port        = 22
  egress         = false
  network_acl_id = aws_network_acl.vpc_security_acl.id
  rule_action    = "allow"
  rule_number    = 99
  cidr_block     = var.office_cidr_range
}

# Create the Route Table
resource "aws_route_table" "postgres_vpc_route_table" {
  vpc_id = aws_vpc.postgres_vpc.id
  tags = {
    Name           = "${var.resource_prefix} Route Table"
    Environment    = var.environment
    TerraformStack = var.resource_prefix
  }
}

# Associate the Route Table with the Subnets
resource "aws_route_table_association" "postgres_vpc_private_subnet_association" {
  count          = length(aws_subnet.db_subnets.*.id)
  subnet_id      = aws_subnet.db_subnets[count.index].id
  route_table_id = aws_route_table.postgres_vpc_route_table.id
}

resource "aws_vpc_endpoint" "ssm_endpoint" {
  service_name        = "com.amazonaws.${data.aws_region.current_region.name}.ssm"
  vpc_id              = aws_vpc.postgres_vpc.id
  vpc_endpoint_type   = "Interface"
  auto_accept         = true
  subnet_ids          = aws_subnet.db_subnets.*.id
  security_group_ids  = [aws_security_group.postgres_security_group.id]
  private_dns_enabled = true

  tags = {
    Name           = "${var.resource_prefix} SSM Endpoint"
    Environment    = var.environment
    TerraformStack = var.resource_prefix
  }
}
