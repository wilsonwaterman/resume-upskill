module "website-bucket" {
    source      = "../modules/s3"
    BUCKET_NAME = var.BUCKET_NAME
    CF_ARN      = module.cloudfront-distro.CF_ARN
}

module "cloudfront-distro" {
    source              = "../modules/cloudfront"
    BUCKET_NAME         = module.website-bucket.BUCKET_NAME
    BUCKET_DOMAIN       = module.website-bucket.BUCKET_DOMAIN
    ACM_ARN             = var.ACM_TEST_ARN
    SITE_DOMAIN         = var.WEBSITE_DOMAIN
    ENV                 = "test"
}