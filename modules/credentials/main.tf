#
# RDS Password
#
resource "random_string" "postgress_password" {
  length           = 32
  special          = true
  override_special = "@"
}

#
# KMS used to encrypt database user and password, and the database itself
#
resource "aws_kms_key" "postgres_kms" {
  description         = "${var.resource_prefix} postgres encryption key"
  enable_key_rotation = true
}

#
# Persist credentials to SSM for future reference
#

locals {
  base_ssm_path = "/${var.environment}/database/postgresql/${var.database_name}"
}

resource "aws_ssm_parameter" "postgresql_password_ssm" {
  name        = "${local.base_ssm_path}/password"
  type        = "SecureString"
  value       = "${random_string.postgress_password.result}"
  description = "Database password of ${var.resource_prefix} postgres"
  key_id      = "${aws_kms_key.postgres_kms.key_id}"
  tags = {
    environment = "${var.environment}"
  }

}


resource "aws_ssm_parameter" "postgresql_username_ssm" {
  name        = "${local.base_ssm_path}/username"
  type        = "SecureString"
  value       = "${var.database_username}"
  description = "Database username of ${var.resource_prefix} postgres"
  key_id      = "${aws_kms_key.postgres_kms.key_id}"
  tags = {
    environment = "${var.environment}"
  }
}
