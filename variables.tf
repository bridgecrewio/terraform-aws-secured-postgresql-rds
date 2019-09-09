variable "environment" {}
variable region {
  default = "us-west-2"
}
variable "allocated_storage" {
  default = "100"
}

variable "engine_version" {
  default = "9.6.9"
}

variable "instance_type" {
  default = "db.t2.micro"
}

variable "storage_type" {
  default = "gp2"
}

variable "iops" {
  default = "0"
}

variable "vpc_id" {}

variable "database_identifier" {}

variable "snapshot_identifier" {
  default = ""
}

variable "database_name" {}

variable "database_password" {}

variable "database_username" {
  default = "awsuser"
}

variable "database_port" {
  default = "5432"
}

variable "backup_retention_period" {
  default = "30"
}

variable "backup_window" {
  # 01:00AM-01:30AM PDT
  default = "08:00-08:30"
}

variable "maintenance_window" {
  # 02:-00AM-03:00AM PDT
  default = "09:00-:10:00"
}

variable "auto_minor_version_upgrade" {
  default = true
}

variable "final_snapshot_identifier" {
  default = "terraform-aws-postgresql-rds-snapshot"
}

variable "skip_final_snapshot" {
  default = true
}

variable "copy_tags_to_snapshot" {
  default = false
}

variable "multi_availability_zone" {
  default = false
}

variable "deletion_protection" {
  default = false
}

variable "subnet_group" {}

variable "parameter_group" {
  default = "default.postgres9.6"
}
