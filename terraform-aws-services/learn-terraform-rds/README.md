# Learn Terraform - Manage AWS RDS

[Manage AWS RDS Instances](https://learn.hashicorp.com/tutorials/terraform/aws-rds?in=terraform/aws) のメモ

outputs.tf に、host, port, user などを定義しておくと良さそう。
`sensitive = true` を設定することを忘れずに。

```bash
psql \
  -h $(terraform output -raw rds_hostname) \
  -p $(terraform output -raw rds_port) \
  -U $(terraform output -raw rds_username) postgres
```

Read replica の追加

`replicate_source_db` をセットしておくと、他の `username`, `password`, `engine`, `allocated_storage` などは、Source 元の設定を使用してくれる。

terraform output に接続情報を文字列の interpolation を使用して吐き出させると便利

```example.tf
output "rds_replica_connection_parameters" {
  description = "RDS replica instance connection parameters"
  value       = "-h ${aws_db_instance.education_replica.address} -p ${aws_db_instance.education_replica.port} -U ${aws_db_instance.education_replica.username} postgres"
}
```
