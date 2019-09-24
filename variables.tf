variable "environment" {
  description = "The environment this deployment is for, i.e. dev / prod / staging etc"
  default     = "dev"
}
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
  default = "db.m4.large"
}

variable "storage_type" {
  default = "gp2"
}

variable "iops" {
  default = "0"
}

variable "vpc_peering_id" {
  type    = string
  default = null
}

variable "snapshot_identifier" {
  default = ""
}

variable "database_name" {
  type        = string
  description = "The name of the database to be created"
}

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
  description = "The maintenance window. must satisfy the format of \"ddd:hh24:mi-ddd:hh24:mi\""
  default     = "sun:09:00-sun:10:00"
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
  default = true
}

variable "deletion_protection" {
  default = false
}

variable "parameter_group" {
  default = "default.postgres9.6"
}

variable "profile" {
  description = "The AWS profile to be used."
  default     = "default"
}

variable "allow_major_version_upgrade" {
  description = "Allows for upgrade of DB software by a major version."
  default = false
}
