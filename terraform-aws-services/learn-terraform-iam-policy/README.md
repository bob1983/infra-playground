# Create IAM policies with Terraform

This is a companion repository to the Terraform IAM policy creation tutorial on [HashiCorp Learn](https://learn.hashicorp.com/tutorials/terraform/aws-iam-policy).

## IAM User の作成

- IAM User の作成
  - `aws_iam_user` resource
- User に割り当てたい Policy の作成
  - `aws_iam_policy` resource の policy にヒアドキュメントでインラインで記述できるが
  - `aws_iam_policy_document` data source で定義した内容を適用した方が再利用性が高くなる
    - `aws_iam_policy_document` は、[source_json と override_json](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document#example-with-source-and-override) があるので、別の `aws_iam_policy_document` からの拡張などもできる
- User と Policy の Mapping
  - `aws_iam_user_policy_attachment` を作る
  - Role や、Group もそれぞれ、該当する policy attachment を作る


