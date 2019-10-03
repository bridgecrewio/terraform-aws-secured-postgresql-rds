# Terraform AWS Secured PostgreSQL RDS
[![GitHub tag (latest SemVer)](https://img.shields.io/github/tag/bridgecrewio/terraform-aws-secured-postgresql-rds.svg?label=latest)](https://github.com/bridgecrewio/terraform-aws-secured-postgresql-rds/releases/latest)
![Terraform Version](https://img.shields.io/badge/tf-%3E%3D0.12.0-blue.svg)
[![CircleCI](https://circleci.com/gh/bridgecrewio/terraform-aws-secured-postgresql-rds.svg?style=svg)](https://circleci.com/gh/bridgecrewio/terraform-aws-secured-postgresql-rds)


A Terraform module to create an Amazon Web Services (AWS) PostgreSQL Relational Database Server (RDS) in a VPC, NAT and security best practices.

## Architecture:
![alt text](https://github.com/bridgecrewio/terraform-aws-secured-postgresql-rds/blob/master/docs/secured-rds-architecture.png "RDS Best Practices")


The username and password to the DB will be stored in AWS System Manager's Parameter store, to be reused by all the 
instances which require access to the DB, and allow for easy password change.

## Configurations:
This module is designed to be highly configurable. The possible inputs and their values:

| Name | Required? | Type | Default Value | Example Value | Description |
|---|---|---|---|---|---|
| database_name| YES | String | | user_actions | The name of the DB instance to be created |
| office_cidr | NO | String | 0.0.0.0/32 | 31.168.227.138/32 | The CIDR of the offices. if left for default value, no rules will be created |
| environment | NO | String | dev | prod | The environment this DB will be part of |
| allocated_storage | NO | Integer | 100 | 250 | The allocated storage size of the DB, in GiB |
| engine_version | NO | String | 9.6 | 10.5 | The version the DB will run on |
| instance_type | NO | String | db.m4.large | db.t2.small | The instance the DB will run on |
| storage_type | NO | String | gp2 | standard | The storage type of the DB instance |
| iops | NO | Integer | 0 | 10000 | The amount of provisioned iops |
| vpc_peering_id | NO | String | null | vpc-123456789 | The ID of a VPC to peer to this VPC |
| database_username | NO | String | awsuser | proddbuser | The username for access to the instance |
| database_port | NO | Integer | 5432 | 8080 | The port to be opened for DB communications |
| backup_retention_period | NO | Integer | 30 | 14 | The number of days backuups will be stored for |
| backup_window | NO | Formatted String | 08:00-08:30 | 12:30-13:00 | The time window, in 24h UTC format, when the backups will take place. |
| maintenance_window | NO | Formatted String | sun:09:00-sun:10:00 | sat:12:00-sat:13:00 | The maintenance window time, in 24h UTC format. Needs to conform to the format ddd:hh24:mi-ddd:hh24:mi |
| auto_minor_version_upgrade | NO | Boolean | true | false | Determines whether to upgrade the engine version if minor updates are released in the upcoming maintenance window or not |
| allow_major_version_upgrade | NO | Boolean | false | true | Determines whether to upgrade the engine version if major updates are released in the upcoming maintenance window or not |
| multi_availability_zone | NO | Boolean | true | false | Specifies if the RDS instance is multi-AZ |
| deletion_protection | NO | Boolean | false | true | The DB can't be deleted while this is set to true |
| monitoring_interval | NO | Integer enum | 0 | 5 | The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. Valid Values: 0, 1, 5, 10, 15, 30, 60. |
| snapshot_identifier | NO | String | null | rds:production-2015-06-26-06-05 | If set, the DB will be created from the specified snapshot identifier |

## Outuput
| Name |  Example Value | Description |
|------|----------------|-------------|
| db_instance_id | dev-secured-rds | DB Identifier | 
| db_vpc_id | vpc-07e819de8f3af8215 | VPC identifier  |
| private_subnet_id | subnet-0a4ec7223e81e0b09 |
| public_subnet_id | subnet-0a4ec7223e81e0b09 |
| database_security_group_id | sg-0c5747d714287d562 | The DB's Security Group ID |
| vpc_network_acl_id | acl-0312f37b1ad3cfca6 | The VPC's Network ACL ID |
| db_username_ssm_parameter | /dev/database/postgresql/secured-rds/username | Path to SecuredString containing PostgresSQL username |
| db_password_ssm_parameter | /dev/database/postgresql/secured-rds/password | Path to SecuredString containing PostgresSQL generated password |
| kms_arn | arn:aws:kms:eu-central-1:090772183824:key/6935c5b9-ff3f-4363-82b4-a709fbeb8a62 | The ARN of the KMS for the SSM parameters and the RDS SSE. |

## Examples:
* How to connect from your office CIDR
To allow connections from your office CIDR, you can do one of the following:
1. Supply the CIDR range of your office as the variable `office_cidr`. This will create an ingress rule in the NACL and
the Security Group for the database port and port 22 (although this port is not open on the RDS).
2. Use the outputs `vpc_network_acl_id` and `database_security_group_id` to add rules to those resources
* [How to connect from another VPC](docs/howTo/connecting-from-external-vpc.md)

