module "website-bucket" {
    source          = "../modules/s3"
    BUCKET_NAME     = var.BUCKET_NAME
    LOG_BUCKET_NAME = var.LOGGING_BUCKET_NAME
    CF_ARN          = module.cloudfront-distro.CF_ARN
}

module "cloudfront-distro" {
    source              = "../modules/cloudfront"
    BUCKET_NAME         = module.website-bucket.BUCKET_NAME
    BUCKET_DOMAIN       = module.website-bucket.BUCKET_DOMAIN
    ACM_ARN             = var.ACM_TEST_ARN
    SITE_DOMAIN         = var.WEBSITE_DOMAIN
    CLOUDFRONT_OAC_NAME = var.OAC_NAME
    ENV                 = "test"
}

module "route53-A-record" {
    source                  = "../modules/route53"
    ROUTE53_HOSTED_ZONE_ID  = var.HOSTED_ZONE
    SITE_DOMAIN             = var.WEBSITE_DOMAIN
    DISTRO_DOMAIN_NAME      = module.cloudfront-distro.DISTRO_DOMAIN_NAME
    CF_HOSTED_ZONE_ID       = module.cloudfront-distro.CF_HOSTED_ZONE_ID
}

module "dynamodb-visitor-count-table" {
    source              = "../modules/dynamodb"
    TABLE_NAME          = var.TABLE_NAME
}

module "visitor-count-function" {
    source                  = "../modules/lambda"
    LAMBDA_FUNCTION_NAME    = var.LAMBDA_FUNCTION_NAME
}