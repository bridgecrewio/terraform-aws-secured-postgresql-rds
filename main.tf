terraform {
  required_version = ">= 0.12.0"
}

provider "aws" {
  region  = var.region
  profile = var.profile
}

module "database" {
  source                     = "./modules/database"
  database_name              = var.database_name
  environment                = var.environment
  allocated_storage          = var.allocated_storage
  engine_version             = var.engine_version
  instance_type              = var.instance_type
  storage_type               = var.storage_type
  iops                       = var.iops
  database_port              = var.database_port
  backup_retention_period    = var.backup_retention_period
  backup_window              = var.backup_window
  maintenance_window         = var.maintenance_window
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  copy_tags_to_snapshot      = var.copy_tags_to_snapshot
  multi_availability_zone    = var.multi_availability_zone
  deletion_protection        = var.deletion_protection
  snapshot_identifier        = var.snapshot_identifier
}


