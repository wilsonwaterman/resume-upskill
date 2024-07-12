variable "API_GATEWAY_NAME" {
}

# GATEWAY
resource "aws_apigatewayv2_api" "visitor-count-gateway" {
    name            = var.API_GATEWAY_NAME
    protocol_type   = "HTTP"
}

# ROUTE
resource "aws_apigatewayv2_integration" "lambda-intg" {
    api_id              = aws_apigatewayv2_api.visitor-count-gateway.id
    integration_type    = "HTTP_PROXY"
    integration_method  = "GET"
}
