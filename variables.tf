variable "environment" {
  description = "The environment this deployment is for, i.e. dev / prod / staging etc"
  default     = "dev"
}

variable "allocated_storage" {
  description = "The allocated storage size of the DB, in GiB"
  default     = "100"
}

variable "engine_version" {
  default = "9.6"
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

variable "instance_name" {
  type        = string
  description = "The name of the database instance to be created"
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

variable "copy_tags_to_snapshot" {
  default = true
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

variable "monitoring_interval" {
  default = "0"
}

variable "snapshot_identifier" {
  default = null
}

variable "allow_major_version_upgrade" {
  type    = bool
  default = false
}

variable "office_cidr" {
  type = string
  description = "The public CIDR range the RDS will be open to. Should be used to be able to directly connect to the RDS from the company offices"
  default = ""
}
