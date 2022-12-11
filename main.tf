data "aws_ami" "amazon2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20221103.3-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"]
}

resource "aws_security_group" "test_sg" {
  name   = "sgservertest"
  vpc_id = var.vpc_id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [var.ipv4_cidr_blocks]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [var.ipv4_cidr_blocks]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.ipv4_cidr_blocks]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sgservertest"
  }
}

resource "aws_instance" "web-test" {
  for_each                = toset(var.int_names)
  ami                     = data.aws_ami.amazon2.id
  instance_type           = var.int_type
  disable_api_termination = var.disable_api_termination
  user_data               = file("./files/userdata.sh")
  vpc_security_group_ids  = [aws_security_group.test_sg.id]
  key_name                = var.key_name
  root_block_device {
    volume_size = 10
    volume_type = "gp2"
  }

  tags = {
    Name = each.key
  }
}

resource "aws_s3_bucket" "s3-kassio-test" {
  bucket = "kassio99-test"
  acl    = "private"
}

resource "aws_sqs_queue" "terraform_test" {
  name                      = "terraform-server-test"
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
