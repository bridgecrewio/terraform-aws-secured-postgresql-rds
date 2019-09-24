#
# CloudWatch resources
#
resource "aws_cloudwatch_metric_alarm" "database_cpu" {
  alarm_name          = "alarm${var.environment}DatabaseServerCPUUtilization-${var.database_identifier}"
  alarm_description   = "Database server CPU utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = var.alarm_cpu_threshold

  dimensions = {
    DBInstanceIdentifier = var.postgresql_id
  }

  alarm_actions             = var.alarm_actions
  ok_actions                = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions
  tags = {
    Environment    = var.environment
    TerraformStack = var.resource_prefix
  }
}

resource "aws_cloudwatch_metric_alarm" "database_disk_queue" {
  alarm_name          = "alarm${var.environment}DatabaseServerDiskQueueDepth-${var.database_identifier}"
  alarm_description   = "Database server disk queue depth"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "DiskQueueDepth"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.alarm_disk_queue_threshold

  dimensions = {
    DBInstanceIdentifier = var.postgresql_id
  }

  alarm_actions             = var.alarm_actions
  ok_actions                = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions
  tags = {
    Environment    = var.environment
    TerraformStack = var.resource_prefix
  }
}

resource "aws_cloudwatch_metric_alarm" "database_disk_free" {
  alarm_name          = "alarm${var.environment}DatabaseServerFreeStorageSpace-${var.database_identifier}"
  alarm_description   = "Database server free storage space"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.alarm_free_disk_threshold

  dimensions = {
    DBInstanceIdentifier = var.postgresql_id
  }

  alarm_actions             = var.alarm_actions
  ok_actions                = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions
  tags = {
    Environment    = var.environment
    TerraformStack = var.resource_prefix
  }
}

resource "aws_cloudwatch_metric_alarm" "database_memory_free" {
  alarm_name          = "alarm${var.environment}DatabaseServerFreeableMemory-${var.database_identifier}"
  alarm_description   = "Database server freeable memory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.alarm_free_memory_threshold

  dimensions = {
    DBInstanceIdentifier = var.postgresql_id
  }

  alarm_actions             = var.alarm_actions
  ok_actions                = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions
  tags = {
    Environment    = var.environment
    TerraformStack = var.resource_prefix
  }
}

resource "aws_cloudwatch_metric_alarm" "database_cpu_credits" {
  // This results in 1 if instance_type starts with "db.t", 0 otherwise.
  count               = substr(var.instance_type, 0, 3) == "db.t" ? 1 : 0
  alarm_name          = "alarm${var.environment}DatabaseCPUCreditBalance-${var.database_identifier}"
  alarm_description   = "Database CPU credit balance"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUCreditBalance"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.alarm_cpu_credit_balance_threshold

  dimensions = {
    DBInstanceIdentifier = var.postgresql_id
  }

  alarm_actions             = var.alarm_actions
  ok_actions                = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions
  tags = {
    Environment    = var.environment
    TerraformStack = var.resource_prefix
  }
}
