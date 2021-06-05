# Learn Terraform Advanced Deployment Strategies

Blue-Green Deployment [ref](https://learn.hashicorp.com/tutorials/terraform/blue-green-canary-tests-deployments?in=terraform/aws) のメモ

main.tf

`aws_lb` と `aws_lb_listener` リソースが定義されている

blue.tf

ALB の設定 `aws_lb_target_group` と、 `aws_lb_target_group_attachment` 及び、EC2 の設定が定義されている。

インスタンスは、 2 台構成になっている。
