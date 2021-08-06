data "aws_ami" "amazon_linux2" {
  most_recent = true
  owners      = ["self", "amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_subnet_ids" "selected" {
  vpc_id = aws_vpc.vpc.id
  filter {
    name   = "tag:Name"
    values = ["${var.project}-${var.environment}-private-subnet-app*"]
  }
}