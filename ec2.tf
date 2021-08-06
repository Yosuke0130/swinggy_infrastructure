# ------------------------
# key pair
# ------------------------
resource "aws_key_pair" "keypair" {
  key_name   = "${var.project}-${var.environment}-keypair"
  public_key = file("./src/swinggy-dev-keypair.pub")

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
  ami                         = data.aws_ami.amazon_linux2.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet_bastion.id
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.api_ec2_profile.name
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  key_name                    = aws_key_pair.keypair.key_name

  tags = {
    Name    = "${var.project}-${var.environment}-bastion-ec2"
    project = var.project
    Env     = var.environment
  }

}

#app Server
resource "aws_instance" "app-server" {
  ami                         = data.aws_ami.amazon_linux2.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private_subnet_app.id
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.api_ec2_profile.name
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  key_name                    = aws_key_pair.keypair.key_name

  tags = {
    Name    = "${var.project}-${var.environment}-app-ec2"
    project = var.project
    Env     = var.environment
  }

  user_data = <<-EOF
    #!bin/bash
    sudo amazon-linux-extras install nginx1
    sudo systemctl start nginx
  EOF
}
resource "aws_instance" "app-server-2" {
  ami                         = data.aws_ami.amazon_linux2.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private_subnet_app_2.id
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.api_ec2_profile.name
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  key_name                    = aws_key_pair.keypair.key_name

  tags = {
    Name    = "${var.project}-${var.environment}-app-2-ec2"
    project = var.project
    Env     = var.environment
  }
}


#DB Server
resource "aws_instance" "db-server" {
  ami                         = data.aws_ami.amazon_linux2.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private_subnet_db.id
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.api_ec2_profile.name
  vpc_security_group_ids      = [aws_security_group.db_sg.id]
  key_name                    = aws_key_pair.keypair.key_name

  tags = {
    Name    = "${var.project}-${var.environment}-db-ec2"
    project = var.project
    Env     = var.environment
  }
}
