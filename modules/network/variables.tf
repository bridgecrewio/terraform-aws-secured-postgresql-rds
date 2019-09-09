variable environment {}
variable resource_prefix {}
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

variable subnet_cidr_block {
  type    = "string"
  default = "10.0.0.0/24"
}

