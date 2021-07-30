# ------------------------
# Security Group
# ------------------------
# bastion security group
resource "aws_security_group" "bastion_sg" {
  name        = "${var.project}-${var.environment}-bastion-sg"
  description = "security group for bastion server"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name    = "${var.project}-${var.environment}-bastion-sg"
    project = var.project
    Env     = var.environment
  }
}
resource "aws_security_group_rule" "bastion_in_http" {
  security_group_id = aws_security_group.bastion_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "bastion_in_https" {
  security_group_id = aws_security_group.bastion_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "bastion_out_http" {
  security_group_id        = aws_security_group.bastion_sg.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = 80
  to_port                  = 80
  source_security_group_id = aws_security_group.api_sg.id
}
resource "aws_security_group_rule" "bastion_out_https" {
  security_group_id        = aws_security_group.bastion_sg.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = 443
  to_port                  = 443
  source_security_group_id = aws_security_group.api_sg.id
}
resource "aws_security_group_rule" "bastion_in_ssh" {
  security_group_id = aws_security_group.bastion_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidercidr_blocks  = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "bastion_out_ssh" {
  security_group_id        = aws_security_group.bastion_sg.id
  type                     = "engress"
  protocol                 = "tcp"
  from_port                = 22
  to_port                  = 22
  source_security_group_id = aws_security_group.api_sg.id
}

# api security group
resource "aws_security_group" "api_sg" {
  name        = "${var.project}-${var.environment}-api-sg"
  description = "security group for api server"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name    = "${var.project}-${var.environment}-api-sg"
    project = var.project
    Env     = var.environment
  }
}
resource "aws_security_group_rule" "api_in_http" {
  security_group_id        = aws_security_group.api_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 80
  to_port                  = 80
  source_security_group_id = [aws_security_group.alb_sg.id, aws_security_group.bastion_sg.id]
}
resource "aws_security_group_rule" "api_in_https" {
  security_group_id        = aws_security_group.api_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 443
  to_port                  = 443
  source_security_group_id = [aws_security_group.alb_sg.id, aws_security_group.bastion_sg.id]
}
resource "aws_security_group_rule" "api_in_ssh" {
  security_group_id        = aws_security_group.api_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 22
  to_port                  = 22
  source_security_group_id = aws_security_group.bastion_sg.id
}
resource "aws_security_group_rule" "api_out_ssh" {
  security_group_id        = aws_security_group.api_sg.id
  type                     = "engress"
  protocol                 = "tcp"
  from_port                = 22
  to_port                  = 22
  source_security_group_id = aws_security_group.db_sg.id
}
resource "aws_security_group_rule" "api_out_tcp3306" {
  security_group_id        = aws_security_group.api_sg.id
  type                     = "engress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.db_sg.id
}

# db security group
resource "aws_security_group" "db_sg" {
  name        = "${var.project}-${var.environment}-db-sg"
  description = "security group for db server"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name    = "${var.project}-${var.environment}-db-sg"
    project = var.project
    Env     = var.environment
  }
}
resource "aws_security_group_rule" "db_in_tcp3306" {
  security_group_id        = aws_security_group.db_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.api_sg.id
}

resource "aws_security_group_rule" "db_in_ssh" {
  security_group_id        = aws_security_group.db_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 22
  to_port                  = 22
  source_security_group_id = aws_security_group.api_sg.id
}

# alb security group
resource "aws_security_group" "alb_sg" {
  name        = "${var.project}-${var.environment}-alb-sg"
  description = "security group for alb"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name    = "${var.project}-${var.environment}-alb-sg"
    project = var.project
    Env     = var.environment
  }
}
resource "aws_security_group_rule" "alb_in_http" {
  security_group_id        = aws_security_group.alb_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 80
  to_port                  = 80
  source_security_group_id = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "alb_in_https" {
  security_group_id        = aws_security_group.alb_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 443
  to_port                  = 443
  source_security_group_id = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "alb_out_http" {
  security_group_id        = aws_security_group.alb_sg.id
  type                     = "engress"
  protocol                 = "tcp"
  from_port                = 80
  to_port                  = 80
  source_security_group_id = aws_security_group.api_sg.id
}
resource "aws_security_group_rule" "alb_out_https" {
  security_group_id        = aws_security_group.alb_sg.id
  type                     = "engress"
  protocol                 = "tcp"
  from_port                = 443
  to_port                  = 443
  source_security_group_id = aws_security_group.api_sg.id
}