resource "aws_instance" "web-test" {
  for_each                = toset(var.int_names)
  ami                     = var.amis[var.region]
  instance_type           = var.int_type
  disable_api_termination = var.disable_api_termination

  tags = {
    Name = each.key
  }
}

resource "aws_s3_bucket" "s3-kassio-test" {
  bucket = "kassio99-test"
  acl    = "private"
}

resource "aws_sqs_queue" "terraform_queue" {
  name                      = "terraform--queue"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10

  tags = {
    Environment = "production"
  }
}

module "vpc" {
  source    = "github.com/kassio99/terraform-aws-vpc.git"
  vpc_name  = "test"
  vpc_cidr  = "172.32.0.0/16"
  nat_count = 1
}
