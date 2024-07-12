variable "LAMBDA_FUNCTION_NAME" {
}

data "aws_iam_policy_document" "assume_role" {
    statement {
        effect          = "Allow"

        principals {
            type        = "Service"
            identifiers = ["lambda.amazonaws.com"]
        }

        actions         = ["sts:AssumeRole"]
    }
}

resource "aws_iam_role" "iam_for_lambda" {
    name                = "iam_for_lambda"
    assume_role_policy  = data.aws_iam_policy_document.assume_role.json
}

resource "aws_lambda_function" "visitor-count-function" {
    filename            = "../../serverless/counter.zip"
    function_name       = var.LAMBDA_FUNCTION_NAME
    role                = "arn:aws:iam::649148530717:role/service-role/http-crud-tutorial-role"
    runtime             = "python3.12"
    handler             = "lambda_handler"
}