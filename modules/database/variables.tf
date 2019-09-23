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
  default = "db.t2.small"
}

variable "storage_type" {
  default = "gp2"
}

variable "iops" {
  default = "0"
}
variable "database_name" {}


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
  default = "sun:09:00-sun:10:00"
}

variable "auto_minor_version_upgrade" {
  default = true
}


variable "copy_tags_to_snapshot" {
  default = true
}

variable "multi_availability_zone" {
  default = false
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
  default = ""
}