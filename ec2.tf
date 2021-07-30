# ------------------------
# key pair
# ------------------------
resource "aws_key_pair" "keypair" {
  key_name   = "${var.project}-${var.environment}-keypair"
  public_key = file("./src/test-swinggy-keypair.pub")

  tags = {
    Name    = "${var.project}-${var.environment}-keypair"
    project = var.project
    Env     = var.environment
  }
}

# ------------------------
# EC2 instance
# ------------------------
#bastion Server
resource "aws_instance" "bastion-server" {
  ami                         = data.aws_ami.api.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet_bastion.id
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.app_ec2_profile.name
  vpc_security_group_ids      = aws_security_group.bastion_sg.id
  key_name = aws_key_pair.keypair.key_name

  tags = {
    Name    = "${var.project}-${var.environment}-bastion-ec2"
    project = var.project
    Env     = var.environment
  }
}

#bastion Server


#DB Server

