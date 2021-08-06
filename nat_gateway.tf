# ------------------------
# NAT Gateway
# ------------------------
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip_nat_gtw.id
  subnet_id     = aws_subnet.public_subnet_bastion.id
  depends_on    = [aws_internet_gateway.igw]

  tags = {
    Name    = "${var.project}-${var.environment}-nat-gateway"
    Project = var.project
    Env     = var.environment
  }
}

# ------------------------
# Elastic IP
# ------------------------
resource "aws_eip" "eip_nat_gtw" {
  vpc = true

  tags = {
    Name    = "${var.project}-${var.environment}-eip"
    project = var.project
    Env     = var.environment
  }
}

