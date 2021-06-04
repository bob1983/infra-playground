terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.24.1"
    }
  }
}

provider "aws" {
  region = var.region
  profile = var.profile
}

resource "random_pet" "pet_name" {
  length    = 3
  separator = "-"
}

resource "aws_iam_user" "new_user" {
  name = "new_user"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "${random_pet.pet_name.id}-bucket"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

data "aws_iam_policy_document" "s3-all" {
  statement {
    actions   = ["s3:ListAllMyBuckets"]
    resources = ["arn:aws:s3:::*"]
    effect = "Allow"
  }
  statement {
    actions   = ["s3:*"]
    resources = [aws_s3_bucket.bucket.arn]
    effect = "Allow"
  }
}

resource "aws_iam_policy" "policy" {
  name        = "${random_pet.pet_name.id}-policy"
  description = "My test policy"

  policy = data.aws_iam_policy_document.s3-all.json
}

resource "aws_iam_user_policy_attachment" "policy-attachment" {
  user = aws_iam_user.new_user.name
  policy_arn = aws_iam_policy.policy.arn
}

output "rendered_policy" {
  value = data.aws_iam_policy_document.s3-all.json
}
