variable "BUCKET_NAME" {
}

variable "CF_ARN" {
}

variable "LOG_BUCKET_NAME"{
}

# SITE HOSTING BUCKET CREATE AND CONFIG

data "aws_iam_policy_document" "allow-object-access" {
    version             = "2008-10-17"
    statement {
        sid             = "AllowCloudFrontServicePrincipal"
        effect          = "Allow"
        principals {
            type        = "Service"
            identifiers = ["cloudfront.amazonaws.com"]
        }
        actions         = [
            "s3:GetObject"
        ]
        resources       = [
            "${aws_s3_bucket.bucket.arn}/*"
        ]

        # Update condition value after cloudfront terraform code is completed
        condition {
            test        = "ForAnyValue:StringEquals"
            variable    = "AWS:SourceArn"
            values      = ["${var.CF_ARN}"]

        }
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
    ignore_public_acls      = true
    restrict_public_buckets = true
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

# LOGS BUCKET CREATE AND CONFIG

data "aws_iam_policy_document" "put-log-policy" {
    version             = "2012-10-17"
    statement {
        sid             = "S3ServerAccessLogsPolicy"
        effect          = "Allow"
        principals {
            type        = "Service"
            identifiers = ["logging.s3.amazonaws.com"]
        }
        actions         = [
            "s3:PutObject"
        ]
        resources       = [
            "${aws_s3_bucket.logging-bucket.arn}/*"
        ]
    }
}

resource "aws_s3_bucket" "logging-bucket" {
    bucket          = var.LOG_BUCKET_NAME
    force_destroy   = true
}

resource "aws_s3_bucket_logging" "logging-bucket-config" {
    bucket                          = aws_s3_bucket.bucket.id
    target_bucket                   = aws_s3_bucket.logging-bucket.id
    target_prefix                   = "log/"

    target_object_key_format {
        partitioned_prefix {
            partition_date_source   = "DeliveryTime"
        } 
    }
}

resource "aws_s3_bucket_acl" "logging-bucket-acl-settings" {
    depends_on          = [
        aws_s3_bucket_ownership_controls.owner-controls-logging,
        aws_s3_bucket_public_access_block.logging-bucket-access-settings,
    ]
    bucket          = aws_s3_bucket.logging-bucket.id
    acl             = "log-delivery-write"
}

resource "aws_s3_bucket_ownership_controls" "owner-controls-logging" {
    bucket                  = aws_s3_bucket.logging-bucket.id
    rule {
        object_ownership    = "BucketOwnerPreferred"
    }          
}

resource "aws_s3_bucket_public_access_block" "logging-bucket-access-settings" {
    bucket                  = aws_s3_bucket.logging-bucket.id
    block_public_acls       = false
    block_public_policy     = false
    ignore_public_acls      = true
    restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "allow-put-logs-access" {
    # This needs to be applied after the bucket ACL is set
    depends_on      = [
        aws_s3_bucket_acl.logging-bucket-acl-settings,
    ]

    bucket          = aws_s3_bucket.logging-bucket.id
    policy          = data.aws_iam_policy_document.put-log-policy.json
}

output "BUCKET_NAME" {
    value           = aws_s3_bucket.bucket.bucket
}

output "BUCKET_DOMAIN" {
    value           = aws_s3_bucket.bucket.bucket_regional_domain_name
}

