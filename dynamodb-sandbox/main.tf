provider "aws" {
  version = "~> 2.0"
  region  = "ap-northeast-1"
}

resource "aws_dynamodb_table" "example" {
  name           = "user_posts"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "user_id"
  range_key      = "timestamp"

  attribute {
    name = "user_id"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "N"
  }

  attribute {
      name = "title"
      type = "S"
  }

  attribute {
    name = "cat"
    type = "S"
  }

  attribute {
    name = "note_id"
    type = "S"
  }

  local_secondary_index {
    name = "user_id-title-index"
    range_key  = "title"
    projection_type = "ALL"
    non_key_attributes = []
  }

  local_secondary_index {
      name = "user_id-cat-index"
      range_key = "cat"
      projection_type = "ALL"
      non_key_attributes = []
  }

  global_secondary_index {
    name            = "note_id-index"
    hash_key        = "note_id"
    write_capacity  = 1
    read_capacity   = 1
    projection_type = "ALL"
  }

  tags = {
    Name = "example table"
  }
}
