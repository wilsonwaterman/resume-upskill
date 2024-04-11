module "website-bucket" {
    source      = "../modules/s3"
    BUCKET_NAME = var.BUCKET_NAME
}

module "cloudfront-distro" {
    source              = "../modules/cloudfront"
    BUCKET_NAME         = module.website-bucket.BUCKET_NAME
    BUCKET_DOMAIN       = module.website-bucket.BUCKET_DOMAIN
    ACM_ARN             = "arn:aws:acm:us-east-1:649148530717:certificate/d5f8829f-79f4-48de-9fb5-2b2207a13e61"
}