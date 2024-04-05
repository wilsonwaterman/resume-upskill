module "website-bucket" {
    source      = "../modules/s3"
    BUCKET_NAME = var.BUCKET_NAME
}