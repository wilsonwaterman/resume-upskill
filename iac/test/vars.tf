variable "AWS_REGION" {
    default = "us-west-2"
}

variable "BUCKET_NAME" {
    default = "wwaterman-test-bucket-778"
}

variable "ACM_TEST_ARN" {
    default = "arn:aws:acm:us-east-1:649148530717:certificate/34997f00-c6f2-497f-ab38-ada25de66207"
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