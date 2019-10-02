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
  type    = "string"
  default = "10.0.0.0/16"
}

variable primary_subnet_cidr_block {
  type    = "string"
  default = "10.0.1.0/24"
}

variable secondary_subnet_cidr_block {
  type    = "string"
  default = "10.0.2.0/24"
}

variable "postgress_internet_cidr" {
  default = "0.0.0.0/0"
}

variable "office_cidr_range" {
  type = string
  default = ""
}