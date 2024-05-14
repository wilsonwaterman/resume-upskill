variable "AWS_REGION" {
    default = "us-west-2"
}

variable "BUCKET_NAME" {
    default = "wilsonwaterman.com"
}

variable "ACM_PROD_ARN" {
    default = "arn:aws:acm:us-east-1:649148530717:certificate/7eaf2f1c-15df-42d6-988f-0ba3fc401123"
}

variable "WEBSITE_DOMAIN" {
    default = "wilsonwaterman.com"
}

variable "HOSTED_ZONE" {
    default = "Z0687184A3EVRV7AE6DP"
}

variable "OAC_NAME" {
    default = "s3-OAC-PROD"
}

variable "LOGGING_BUCKET_NAME" {
    default = "wilsonwaterman.com-logs"
}