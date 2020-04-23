# DynamoDB sandbox

AWSのConfig設定を事前にしておく

## Create dynamodb

```shell
terraform init # First time
terraform apply
```


## TerraformのResource定義
基本的には公式の[サンプル](https://www.terraform.io/docs/providers/aws/r/dynamodb_table.html)に従う

LSIの定義のみサンプルが無いので、↓のようにする。

- `name` LSIの名前
- `range_key` Index対象のキー(LSIの時点でhashkeyはPK固定なので定義不要)
- `projection_type`
- `non_key_attributes`

```tf
  local_secondary_index {
    name = "user_id-title-index"
    range_key  = "title"
    projection_type = "ALL"
    non_key_attributes = []
  }
```

## Manage table items

[table-operations.js](src/table-operations.js)に基本的な操作を書いてある

