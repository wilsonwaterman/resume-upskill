variable "BUCKET_NAME" {
}

data "aws_iam_policy_document" "allow-object-access" {
    version         = "2012-10-17"
    statement {
        sid         = "PublicReadGetObject"
        effect      = "Allow"
        principals {
            type        = "*"
            identifiers = ["*"]
        }
        actions     = [
            "s3:GetObject"
        ]
        resources   = [
            "${aws_s3_bucket.bucket.arn}/*"
         #  "arn:aws:s3:::${var.BUCKET_NAME}/*"
        ]
    }
}

data "aws_canonical_user_id" "current" {}

resource "aws_s3_bucket" "bucket" {
    bucket          = var.BUCKET_NAME
    force_destroy   = true
}

resource "aws_s3_bucket_ownership_controls" "owner-controls" {
    bucket                  = aws_s3_bucket.bucket.id
    rule {
        object_ownership    = "BucketOwnerPreferred"
    }          
}

resource "aws_s3_bucket_public_access_block" "bucket-access-settings" {
    bucket                  = aws_s3_bucket.bucket.id
    block_public_acls       = false
    block_public_policy     = false
    ignore_public_acls      = false
    restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "bucket-acl-settings" {
    depends_on          = [
        aws_s3_bucket_ownership_controls.owner-controls,
        aws_s3_bucket_public_access_block.bucket-access-settings,
    ]

    bucket              = aws_s3_bucket.bucket.id
    access_control_policy {
        grant {
            grantee {
                id      = data.aws_canonical_user_id.current.id
                type    = "CanonicalUser"
            }
            permission  = "FULL_CONTROL"
        }

        grant {
            grantee {
                type    = "Group"
                uri     = "http://acs.amazonaws.com/groups/global/AllUsers"
            }
            permission  = "READ_ACP"
        }

        owner {
            id          = data.aws_canonical_user_id.current.id
        }
    }
}

resource "aws_s3_bucket_policy" "allow-access-to-public" {
    # This needs to be applied after the bucket ACL is set
    depends_on      = [
        aws_s3_bucket_acl.bucket-acl-settings,
    ]

    bucket          = aws_s3_bucket.bucket.id
    policy          = data.aws_iam_policy_document.allow-object-access.json
}

resource "aws_s3_bucket_website_configuration" "web-config" {
    bucket          = aws_s3_bucket.bucket.id

    index_document {
        suffix      = "index.html"
    }
}

