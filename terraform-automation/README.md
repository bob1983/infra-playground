# Running Terrraform automation

[Terraform の公式](https://learn.hashicorp.com/tutorials/terraform/automate-terraform?in=terraform/automation) のメモ

## Terraform CLI の自動化の Workflow

自動化する上での workflow

- working directory の初期化
  - `terraform init -input=false`
- plan の実行
  - `terraform plan -out=tfplan -input=false`
- plan 結果を確認 -> approve
- apply
  - `terraform apply -input=false tfplan`

`-input=false` は、variable が未設定の場合の prompt などを出さないようにする設定。

