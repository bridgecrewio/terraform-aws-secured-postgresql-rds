# How to connect via Office CIDR
### Configuration
To allow connections from your office CIDR, you can do one of the following:
1. Supply the CIDR range of your office as the variable `office_cidr`. This will create an ingress rule in the NACL and
the Security Group for the database port and port 22 (although this port is not open on the RDS).
 
   Example configuration: 
   ```
    module "secure_rds" {
      source         = "bridgecrewio/secured-postgresql-rds/aws"
      version        = "0.5.0"
      instance_name  = "secured-rds"
      environment    = "dev"
      office_cidr    = "31.168.227.138/32"
    }
    ``` 
2. Use the outputs `vpc_network_acl_id` and `database_security_group_id` to add rules to those resources. The relevant 
resources are the terraform resources [network_acl_rule](https://www.terraform.io/docs/providers/aws/r/network_acl_rule.html)
and [security_group_rule](https://www.terraform.io/docs/providers/aws/r/security_group_rule.html).