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


resource "aws_ssm_maintenance_window" "example-window" {
  name                       = "example"
  schedule                   = "cron(0 6 ? * * *)"
  duration                   = 1
  cutoff                     = 0
  description                = "Example maintenance window"
  allow_unassociated_targets = true
}

resource "aws_ssm_maintenance_window_target" "example-window-target" {
  window_id     = aws_ssm_maintenance_window.example-window.id
  name          = "example-window-target"
  resource_type = "INSTANCE"

  targets {
    key    = "tag:Service"
    values = ["example-ssm"]
  }
}

resource "aws_ssm_maintenance_window_task" "example-window-task" {
  max_concurrency = 1
  max_errors      = 1
  task_arn        = "AWS-RunShellScript"
  task_type       = "RUN_COMMAND"
  window_id       = aws_ssm_maintenance_window.example-window.id

  targets {
    key    = "WindowTargetIds"
    values = [aws_ssm_maintenance_window_target.example-window-target.id]
  }

  task_invocation_parameters {
    run_command_parameters {
      service_role_arn = aws_iam_service_linked_role.ssm.arn

      parameter {
        name = "commands"
        values = [
          "df"
        ]
      }

      parameter {
        name   = "workingDirectory"
        values = [""]
      }
    }
  }
}

