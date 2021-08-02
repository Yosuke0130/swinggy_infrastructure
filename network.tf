# ------------------------
# VPC
# ------------------------
resource "aws_vpc" "vpc" {
  cidr_block                       = "172.0.0.0/16"
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name    = "${var.project}-${var.environment}-vpc"
    project = var.project
    Env     = var.environment
  }
}

# ------------------------
# Subnet
# ------------------------
resource "aws_subnet" "public_subnet_bastion" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "172.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project}-${var.environment}-public-subnet-bastion"
    project = var.project
    Env     = var.environment
    type    = "public"
  }
}

resource "aws_subnet" "private_subnet_app" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "172.0.2.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name    = "${var.project}-${var.environment}-public-subnet-app"
    project = var.project
    Env     = var.environment
    type    = "private"
  }
}
resource "aws_subnet" "private_subnet_app_2" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = "172.0.4.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name    = "${var.project}-${var.environment}-public-subnet-app_2"
    project = var.project
    Env     = var.environment
    type    = "private"
  }
}

resource "aws_subnet" "private_subnet_db" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "172.0.3.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name    = "${var.project}-${var.environment}-public-subnet-db"
    project = var.project
    Env     = var.environment
    type    = "private"
  }
}

# ------------------------
# Root Table
# ------------------------
resource "aws_route_table" "public_rt_bastion" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name    = "${var.project}-${var.environment}-public-rt-bastion"
    project = var.project
    Env     = var.environment
    type    = "public"
  }
}
resource "aws_route_table_association" "pubic_rt_bastion" {
  route_table_id = aws_route_table.public_rt_bastion.id
  subnet_id      = aws_subnet.public_subnet_bastion.id
}

resource "aws_route_table" "private_rt_app" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name    = "${var.project}-${var.environment}-private-rt-app"
    project = var.project
    Env     = var.environment
    type    = "private"
  }
}
resource "aws_route_table_association" "private_rt_app" {
  route_table_id = aws_route_table.private_rt_app.id
  subnet_id      = aws_subnet.private_subnet_app.id
}

resource "aws_route_table" "private_rt_db" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name    = "${var.project}-${var.environment}-private-rt-db"
    project = var.project
    Env     = var.environment
    type    = "private"
  }
}
resource "aws_route_table_association" "private_rt_db" {
  route_table_id = aws_route_table.private_rt_db.id
  subnet_id      = aws_subnet.private_subnet_db.id
}

# ------------------------
# Internet Gateway
# ------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name    = "${var.project}-${var.environment}-igw"
    project = var.project
    Env     = var.environment
  }
}
resource "aws_route" "public_rt_igw_r" {
  route_table_id         = aws_route_table.public_rt_bastion.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}