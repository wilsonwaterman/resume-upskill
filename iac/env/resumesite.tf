module "website-bucket" {
    source      = "../modules/s3"
    BUCKET_NAME = "ww-test-bucket-create-tf-778"
}