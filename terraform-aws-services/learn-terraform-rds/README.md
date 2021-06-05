# Learn Terraform - Manage AWS RDS

[Manage AWS RDS Instances](https://learn.hashicorp.com/tutorials/terraform/aws-rds?in=terraform/aws) のメモ

psql \
  -h $(terraform output -raw rds_hostname) \
  -p $(terraform output -raw rds_port) \
  -U $(terraform output -raw rds_username) postgres
