variable "AWS_REGION" {
    default = "us-west-2"
}

variable "BUCKET_NAME" {
    default = "wwaterman-test-bucket-778"
}

variable "ACM_TEST_ARN" {
    default = "arn:aws:acm:us-east-1:649148530717:certificate/7eaf2f1c-15df-42d6-988f-0ba3fc401123"
}

variable "WEBSITE_DOMAIN" {
    default = "test.wilsonwaterman.com"
}

variable "HOSTED_ZONE" {
    default = "Z0687184A3EVRV7AE6DP"
}

variable "OAC_NAME" {
    default = "s3-OAC-TEST"
}

variable "LOGGING_BUCKET_NAME" {
    default = "wwaterman-test-bucket-778-logs"
}