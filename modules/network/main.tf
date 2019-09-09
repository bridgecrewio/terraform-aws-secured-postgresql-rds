
resource "aws_vpc" "postgres_vpc" {
  cidr_block = "${var.vpc_cidr_block}"

  tags = {
    Name = "${var.resource_prefix} vpc"
    environment = "${var.environment}"
  }
}

resource "aws_subnet" "postgres_subnet" {
  vpc_id     = "${aws_vpc.postgres_vpc.id}"
  cidr_block = "${var.subnet_cidr_block}"
  tags = {
    Name = "${var.resource_prefix} subnet"
    environment = "${var.environment}"
  }
}

resource "aws_db_subnet_group" "postgres_subnet_group" {
  name       = "${var.resource_prefix}subnet_group"
  subnet_ids = ["${aws_subnet.postgres_subnet.id}"]

  tags = {
    Name = "${var.resource_prefix} subnet group"
    environment = "${var.environment}"

  }
}

resource "aws_security_group" "postgres_security_group" {
  vpc_id      = "${aws_vpc.postgres_vpc.id}"
  name        = "${var.resource_prefix} security group"
  description = "postgres security group"
  ingress {
    cidr_blocks = ["${var.vpc_cidr_block}"]
    from_port   = "${var.database_port}"
    to_port     = "${var.database_port}"
    protocol    = "tcp"
  }
  tags = {
    environment = "${var.environment}"
  }
}

# create VPC Network access control list
resource "aws_network_acl" "postgres_security_acl" {
  vpc_id = "${aws_vpc.postgres_vpc.id}"
  subnet_ids = [
  "${aws_subnet.postgres_subnet.id}"]
  # allow port "${var.postgres_port}"
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "${var.vpc_cidr_block}"
    from_port  = "${var.database_port}"
    to_port    = "${var.database_port}"
  }
  # allow ingress ephemeral ports
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "${var.vpc_cidr_block}"
    from_port  = "${var.database_port}"
    to_port    = "${var.database_port}"
  }
  # allow egress ephemeral ports
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "${var.vpc_cidr_block}"
    from_port  = "${var.database_port}"
    to_port    = "${var.database_port}"
  }
  tags = {
    Name = "${var.resource_prefix} vpc ACL"
    environment = "${var.environment}"
  }
}

# Create the Route Table
resource "aws_route_table" "postgres_vpc_route_table" {
  vpc_id = "${aws_vpc.postgres_vpc.id}"
  tags = {
    Name = "${var.resource_prefix} Route Table"
    environment = "${var.environment}"
  }
}

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "postgres_vpc_association" {
  subnet_id      = "${aws_subnet.postgres_subnet.id}"
  route_table_id = "${aws_route_table.postgres_vpc_route_table.id}"
}
