# ------------------------
# API Gateway
# ------------------------
resource "aws_apigatewayv2_api" "api_gtw" {
  name          = "${var.project}-${var.environment}-api-gateway"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_vpc_link" "vpc_link" {
  name               = "${var.project}-${var.environment}-vpc-link"
  security_group_ids = [aws_security_group.vpc_link_sg.id]
  subnet_ids         = data.aws_subnet_ids.selected.ids

  tags = {
    Name    = "${var.project}-${var.environment}-vpc-link"
    project = var.project
    Env     = var.environment
  }
}

resource "aws_apigatewayv2_integration" "api_gtw_integration" {
  api_id             = aws_apigatewayv2_api.api_gtw.id
  connection_id      = aws_apigatewayv2_vpc_link.vpc_link.id
  connection_type    = "VPC_LINK"
  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"
  integration_uri    = aws_lb_listener.alb_listener_http.arn
}

resource "aws_apigatewayv2_route" "api_gtw_route" {
  api_id    = aws_apigatewayv2_api.api_gtw.id
  route_key = "ANY /swinggy-api/{proxy+}"
}