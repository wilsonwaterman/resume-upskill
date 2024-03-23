module "website-bucket" {
    source      = "../modules/s3"
    BUCKET_NAME = "resume-upskill-778"
}