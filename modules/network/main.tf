
resource "aws_vpc" "postgres_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name           = "${var.resource_prefix} vpc"
    Environment    = var.environment
    TerraformStack = var.resource_prefix
  }
}

resource "aws_subnet" "postgres_secondary_subnet" {
  vpc_id     = aws_vpc.postgres_vpc.id
  cidr_block = var.secondary_subnet_cidr_block
  tags = {
    Name           = "${var.resource_prefix} secondary subnet"
    Environment    = var.environment
    TerraformStack = var.resource_prefix
  }
}

resource "aws_subnet" "postgres_primary_subnet" {
  vpc_id     = aws_vpc.postgres_vpc.id
  cidr_block = var.primary_subnet_cidr_block
  tags = {
    Name           = "${var.resource_prefix} primary subnet"
    Environment    = var.environment
    TerraformStack = var.resource_prefix
  }
}

resource "aws_db_subnet_group" "postgres_subnet_group" {
  name       = "${var.resource_prefix}subnet_group"
  subnet_ids = [aws_subnet.postgres_primary_subnet.id, aws_subnet.postgres_secondary_subnet.id]

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
    cidr_blocks = [
      var.vpc_cidr_block
    ]
    from_port = var.database_port
    to_port   = var.database_port
    protocol  = "tcp"
  }
  ingress {
    cidr_blocks = [
      var.postgress_internet_cidr
    ]
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }
  tags = {
    Environment    = var.environment
    TerraformStack = var.resource_prefix
  }
}

# Create the Internet Gateway
resource "aws_internet_gateway" "postgress_gw" {
  vpc_id = aws_vpc.postgres_vpc.id
  tags = {
    Name           = var.resource_prefix
    TerraformStack = var.resource_prefix
  }
}

# Create the Internet Access

resource "aws_route" "postgress_internet_access" {
  route_table_id         = aws_route_table.postgres_vpc_route_table.id
  destination_cidr_block = var.postgress_internet_cidr
  gateway_id             = aws_internet_gateway.postgress_gw.id
}

# create VPC Network access control list
resource "aws_network_acl" "postgres_security_acl" {
  vpc_id = aws_vpc.postgres_vpc.id
  subnet_ids = [
    aws_subnet.postgres_primary_subnet.id,
    aws_subnet.postgres_secondary_subnet.id
  ]
  # allow port "${var.postgres_port}"
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.vpc_cidr_block
    from_port  = var.database_port
    to_port    = var.database_port
  }

  # allow ingress ephemeral ports
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.vpc_cidr_block
    from_port  = var.database_port
    to_port    = var.database_port
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
  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = var.postgress_internet_cidr
    from_port  = 22
    to_port    = 22
  }
  tags = {
    Name           = "${var.resource_prefix} vpc ACL"
    Environment    = var.environment
    TerraformStack = var.resource_prefix
  }
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

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "postgres_vpc_association" {
  subnet_id      = aws_subnet.postgres_primary_subnet.id
  route_table_id = aws_route_table.postgres_vpc_route_table.id
}
