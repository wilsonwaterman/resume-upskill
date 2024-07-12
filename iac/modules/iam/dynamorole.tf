variable ROLE_NAME {
}

variable LAMBDA_FUNCTION_ARN {
}

variable LAMBDA_FUNCTION_LOGS_ARN {
}

variable DYNAMODB_TABLE_ARN {
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

data "aws_iam_policy_document" "lambda-basic-execution-inline-one" {
    version                 = "2012-10-17"
    statement {
        effect              = "Allow"
        actions             = [
            "logs:CreateLogGroup"
        ]
        resources           = [
            "arn:aws:logs:us-west-2:649148530717:*"
        ]

        effect              = "Allow"
        actions             = [
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ]
        resources           = [
            "${var.LAMBDA_FUNCTION_LOGS_ARN}"
        ]
    }
}

data "aws_iam_policy_document" "lambda-basic-execution-inline-two" {
    version                 = "2012-10-17"
    statement {
        effect              = "Allow"
        actions             = [
            "dynamodb:DeleteItem",
            "dynamodb:GetItem",
            "dynamodb:PutItem",
            "dynamodb:Scan",
            "dynamodb:UpdateItem"
        ]
        resources           = [
            "${var.DYNAMODB_TABLE_ARN}"
        ]
    }
}

resource "aws_iam_role" "dynamo-lambda-access-role" {
    name                    = var.ROLE_NAME
    assume_role_policy      = data.aws_iam_policy_document.assume_role.json

    inline_policy {
        name                = "AWSLambdaBasicExecutionRoleTest"
        policy              = data.aws_iam_policy_document.lambda-basic-execution-inline-one.json
    }

    inline_policy {
        name                = "AWSLambdaMicroserviceExecutionRoleTest"
        policy              = data.aws_iam_policy_document.lambda-basic-execution-inline-two.json
    }
}