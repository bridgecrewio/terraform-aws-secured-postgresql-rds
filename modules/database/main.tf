provider "aws" {
  region = "${var.region}"

}

locals {
  resources_prefix = "${var.environment}${var.database_name}"
}
module "postgres_credetials" {
  source = "../credentials"
  environment = "${var.environment}"
  resource_prefix = "${local.resources_prefix}"
  database_name = "${var.database_name}"
}

module "postgres_network" {
  source = "../network"
  environment = "${var.environment}"
  resource_prefix = "${local.resources_prefix}"
}


#
# IAM resources
#
data "aws_iam_policy_document" "enhanced_monitoring" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "monitoring.rds.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole"]
  }
}

resource "aws_iam_role" "enhanced_monitoring" {
  name = "${local.resources_prefix}RdsEnhancedMonitoringRole"
  assume_role_policy = "${data.aws_iam_policy_document.enhanced_monitoring.json}"
}

resource "aws_iam_role_policy_attachment" "enhanced_monitoring" {
  role = "${aws_iam_role.enhanced_monitoring.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

data "aws_db_snapshot" "postgresql_snapshot" {
  db_instance_identifier = "${aws_db_instance.postgresql.id}"
  most_recent            = true
}



resource "aws_db_instance" "postgresql" {
  allocated_storage = "${var.allocated_storage}"
  engine = "postgres"
  engine_version = "${var.engine_version}"
  identifier = "${local.resources_prefix}"
  snapshot_identifier = "${var.snapshot_identifier}"
  instance_class = "${var.instance_type}"
  storage_type = "${var.storage_type}"
  iops = "${var.iops}"
  name = "${local.resources_prefix}"
  password = "${module.postgres_credetials.password}"
  username = "${module.postgres_credetials.username}"
  backup_retention_period = "${var.backup_retention_period}"
  backup_window = "${var.backup_window}"
  maintenance_window = "${var.maintenance_window}"
  auto_minor_version_upgrade = "${var.auto_minor_version_upgrade}"
  final_snapshot_identifier = "${local.resources_prefix}FinalSnapshot"
  copy_tags_to_snapshot = "${var.copy_tags_to_snapshot}"
  multi_az = "${var.multi_availability_zone}"
  port = "${var.database_port}"
  vpc_security_group_ids = [
    "${module.postgres_network.security_group_id}"]
  db_subnet_group_name = "${module.postgres_network.subnet_group}"
  parameter_group_name = "${var.parameter_group}"
  storage_encrypted = true
  kms_key_id = "${module.postgres_credetials.kms_key_id}"
  monitoring_interval = "${var.monitoring_interval}"
  monitoring_role_arn = "${var.monitoring_interval > 0 ? aws_iam_role.enhanced_monitoring.arn : ""}"
  deletion_protection = "${var.deletion_protection}"

  tags = {
    Environment = "${var.environment}"
  }
}

module "postgres_monitoring" {
  source = "../monitoring"
  environment = "${var.environment}"
  database_name = "${aws_db_instance.postgresql.name}"
  instance_type = "${aws_db_instance.postgresql.instance_class}"
  database_identifier = "${aws_db_instance.postgresql.identifier}"
  postgresql_id = "${aws_db_instance.postgresql.id}"
  resource_prefix = "${local.resources_prefix}"
}