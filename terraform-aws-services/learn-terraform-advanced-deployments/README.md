# Learn Terraform Advanced Deployment Strategies

Blue-Green Deployment [ref](https://learn.hashicorp.com/tutorials/terraform/blue-green-canary-tests-deployments?in=terraform/aws) のメモ

## 初期状態

main.tf

`aws_lb` と `aws_lb_listener` リソースが定義されている

blue.tf

ALB の設定 `aws_lb_target_group` と、 `aws_lb_target_group_attachment` 及び、EC2 の設定が定義されている。

インスタンスは、 2 台構成になっている。

## green.tf の導入

green.tf を導入する。
基本的には、blue.tf と同様の構成で、`enable_green_env` や、`green_instance_count` など、green 用の変数を利用する。

## デプロイ

green.tf を追加した状態でデプロイをする。
この状態では、ALB は blue のインスタンスのみを対象に listen している状態なので、全ての http リクエストは blue のインスタンスにルーティングされる。

