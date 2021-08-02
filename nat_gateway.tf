# # ------------------------
# # NAT Gateway
# # ------------------------
# resource "aws_nat_gateway" "nat_gateway" {
#   allocation_id = aws_eip.nat_gateway.id
#   subnet_id     = aws_subnet.public_subnet_bastion.id
#   depends_on    = [aws_internet_gateway.igw]

#   tags = {
#     Name    = "${var.project}-${var.environment}-nat-gateway"
#     Project = var.project
#     Env     = var.environment
#   }
# }

