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

## green 環境にもルーティングされるようにする

[ref](https://learn.hashicorp.com/tutorials/terraform/blue-green-canary-tests-deployments?in=terraform/aws#add-feature-toggles-to-route-traffic)

`aws_lb_listener` の `default_action` で、`target_group_arn` を 1 つだけ指定していた部分を、 `forward` を使って、複数の `target_group` と `weight` を指定するようにする。

[stickiness](https://aws.amazon.com/jp/blogs/devops/blue-green-deployments-with-application-load-balancer/)

blue 90 green 10 の割合でルーティングされるように変更してみる

```bash
terraform apply -var 'traffic_distribution=blue-90'
```

次に blue 50 green 50 の割合に変更してみる

```bash
terraform apply -var 'traffic_distribution=split`
```

最後に green 100 に変更してみる

```bash
terraform apply -var 'traffic_distribution=green`
```

## blue 環境を退役させる

green に 100 の割合でルーティングするようにした後は、blue 環境のインスタンスは不要なので、`enable_blue_env=false` を指定して縮退させる

```bash
terraform apply -var 'traffic_distribution=green' -var 'enable_blue_env=false'
```
