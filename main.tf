variable "profile" { }
variable "region"  { }

provider "aws" {
  profile = "${var.profile}"
  region  = "${var.region}"
}

resource "aws_iam_role" "spotfleet_role" {
  name = "aws-ec2-spot-fleet-role"
  assume_role_policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Sid\":\"\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"spotfleet.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}"
}
