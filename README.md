# terraform-aws-secured-postgresql-rds
[![CircleCI](https://circleci.com/gh/bridgecrewio/terraform-aws-secured-postgresql-rds.svg?style=svg)](https://circleci.com/gh/bridgecrewio/terraform-aws-secured-postgresql-rds)


A Terraform module to create an Amazon Web Services (AWS) PostgreSQL Relational Database Server (RDS) in a VPC, NAT and security best practices.

## Architecture:
TODO

The username and password to the DB will be stored in AWS System Manager's Parameter store, to be reused by all the 
instances which require access to the DB, and allow for easy password change.

## Configurations:
This module is designed to be highly configurable. The possible inputs and their values:

| Name | Required? | Type | Default Value | Example Value | Description |
|---|---|---|---|---|---|
| database_name| YES | String | | user_actions | The name of the DB instance to be created |
| environment | NO | String | dev | prod | The environment this DB will be part of |
| allocated_storage | NO | Integer | 100 | The allocated storage size of the DB, in GiB |
| engine_version | NO | String | 9.6 | 10.5 | The version the DB will run on |
| instance_type | NO | String | db.m4.large | db.t2.small | The instance the DB will run on |
| storage_type | NO | String | gp2 | standard | The storage type of the DB instance |
| iops | NO | Integer | 0 | 10000 | The amount of provisioned iops |
| vpc_peering_id | NO | null | vpc-123456789 | The ID of a VPC to peer to this VPC |
| database_username | NO | String | awsuser | proddbuser | The username for access to the instance |
| database_port | NO | Integer | 5432 | 8080 | The port to be opened for DB communications |
| backup_retention_period | NO | Integer | 30 | 14 | The number of days backuups will be stored for |
| backup_window | NO | Formatted String | 08:00-08:30 | 12:30-13:00 | The time window, in 24h UTC format, when the backups will take place. |
| maintenance_window | NO | Formatted String | sun:09:00-sun:10:00 | The maintenance window time, in 24h UTC format. Needs to conform to the format ddd:hh24:mi-ddd:hh24:mi |
| auto_minor_version_upgrade | NO | Boolean | true | false | Determines whether to upgrade the engine version if minor updates are released in the upcoming maintenance window or not |
| allow_major_version_upgrade | NO | Boolean | false | true | Determines whether to upgrade the engine version if major updates are released in the upcoming maintenance window or not |
| multi_availability_zone | NO | Boolean | true | false | Specifies if the RDS instance is multi-AZ |
| deletion_protection | NO | Boolean | false | true | The DB can't be deleted while this is set to true |
| monitoring_interval | NO | Integer enum | 0 | 5 | The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. Valid Values: 0, 1, 5, 10, 15, 30, 60. |
| snapshot_identifier | NO | String | null | rds:production-2015-06-26-06-05 | If set, the DB will be created from the specified snapshot identifier |

