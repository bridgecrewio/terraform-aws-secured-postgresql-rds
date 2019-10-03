variable environment {
  type = string
}

variable resource_prefix {
  type = string
}

variable database_port {
  default = 5432
}
variable "database_username" {
  default = "awsuser"
}
variable vpc_cidr_block {
  type        = "string"
  description = "The VPC CIDR block"
}

variable "office_cidr_range" {
  description = "The CIDR range the database port and SSH port will be open for in these vpcs."
  type        = string
}