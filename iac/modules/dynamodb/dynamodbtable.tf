variable "TABLE_NAME" {
}

resource "aws_dynamodb_table" "counter-table" {
    name            = var.TABLE_NAME
    billing_mode    = "PAY_PER_REQUEST"
    hash_key        = "id"

    attribute {
        name        = "id"
        type        = "S"
    }
}