variable "name"           { }
variable "profile"        { }
variable "region"         { }
variable "key_name"       { }
variable "prices"         { type = "map" }
variable "instance_types" { type = "map" }
variable "instance_type"  { }
variable "vpc_id"         { }

provider "aws" {
  profile = "${var.profile}"
  region  = "${var.region}"
}

resource "aws_iam_role" "spotfleet_role" {
  name               = "spotfleet-role"
  assume_role_policy = "${file("assume_role_policy.json")}"
}

resource "aws_iam_policy_attachment" "spotfleet_role" {
  name       = "EC2SpotFleetRole"
  roles      = ["${aws_iam_role.spotfleet_role.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2SpotFleetRole"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp2"]
  }
}

resource "aws_security_group" "fleet-sample-sg" {
  name        = "${var.name}-sg"
  vpc_id      = "${var.vpc_id}"
  description = "${var.name}-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_spot_fleet_request" "fleet" {
  iam_fleet_role      = "${aws_iam_role.spotfleet_role.arn}"
  spot_price          = "${var.prices["default"]}"
  allocation_strategy = "lowestPrice"
  target_capacity     = 1
  valid_until         = "2018-01-01T00:00:00Z"

  launch_specification {
    instance_type               = "${var.instance_types["${var.instance_type}"]}"
    ami                         = "${data.aws_ami.amazon_linux.id}"
    key_name                    = "${var.key_name}"
    spot_price                  = "${var.prices["${var.instance_type}"]}"
    vpc_security_group_ids      = ["${aws_security_group.fleet-sample-sg.id}"]
    associate_public_ip_address = true

    root_block_device {
      volume_size = "8"
      volume_type = "gp2"
    }
  }
}
