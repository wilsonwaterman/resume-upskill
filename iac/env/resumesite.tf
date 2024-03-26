module "website-bucket" {
    source      = "../modules/s3"
    BUCKET_NAME = "wilsonwaterman.com"
}