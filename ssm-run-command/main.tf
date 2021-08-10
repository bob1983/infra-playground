terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.53"
    }
  }

  required_version = ">= 1.0.4"
}

provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_iam_service_linked_role" "ssm" {
  aws_service_name = "ssm.amazonaws.com"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = {
    Service = "example-ssm"
  }
}

# resource "aws_ssm_maintenance_window" "example-window" {
#   name                       = "example"
#   schedule                   = "cron(0 6 ? * * *)"
#   duration                   = 1
#   cutoff                     = 0
#   description                = "Example maintenance window"
#   schedule_timezone          = "Japan"
#   allow_unassociated_targets = true
# }

# resource "aws_ssm_maintenance_window_target" "example-window-target" {
#   window_id     = aws_ssm_maintenance_window.example-window.id
#   name          = "example-window-target"
#   resource_type = "INSTANCE"

#   targets {
#     key    = "tag:Service"
#     values = ["example-ssm"]
#   }
# }

# resource "aws_ssm_maintenance_window_task" "example-window-task" {
#   max_concurrency = 1
#   max_errors      = 1
#   priority        = 1
#   task_arn        = "AWS-RunShellScript"
#   task_type       = "RUN_COMMAND"
#   window_id       = aws_ssm_maintenance_window.example-window.id

#   targets {
#     key    = "WindowTargetIds"
#     values = [aws_ssm_maintenance_window_target.example-window-target.id]
#   }

#   task_invocation_parameters {
#     run_command_parameters {
#       service_role_arn =  aws_iam_service_linked_role.ssm.arn
#       timeout_seconds  = 360

#       parameter {
#         name = "commands"
#         values = [
#           "df"
#         ]
#       }

#       parameter {
#         name   = "executionTimeout"
#         values = ["360"]
#       }
#     }
#   }
# }

