variable "BUCKET_NAME" {
}

variable "BUCKET_DOMAIN" {
}

variable "ACM_ARN" {
}

variable "ENV" {
}

resource "aws_cloudfront_origin_access_control" "default-cloudfront-oac" {
    name                                = "s3-OAC"
    origin_access_control_origin_type   = "s3"
    signing_behavior                    = "always"
    signing_protocol                    = "sigv4"
}

resource "aws_cloudfront_distribution" "site-host-distro" {
    origin {
        domain_name                     = var.BUCKET_DOMAIN
        origin_access_control_id        = aws_cloudfront_origin_access_control.default-cloudfront-oac.id
        origin_id                       = var.BUCKET_NAME
    }

    enabled                             = true
    is_ipv6_enabled                     = true

    default_cache_behavior {
        # Add cache policy by id
        cache_policy_id                 = "658327ea-f89d-4fab-a63d-7e88639e58f6"
        allowed_methods                 = ["GET","HEAD"]
        cached_methods                  = ["GET","HEAD"]
        target_origin_id                = var.BUCKET_NAME

        viewer_protocol_policy          = "allow-all"
        min_ttl                         = 0
        default_ttl                     = 3600
        max_ttl                         = 86400
    }

    price_class                         = "PriceClass_All"

    restrictions {
        geo_restriction {
            restriction_type            = "whitelist"
            locations                   = ["US","CA","GB"]
        }
    }

    tags = {
        Environment                     = var.ENV
    }

    viewer_certificate {
        acm_certificate_arn             = var.ACM_ARN
        ssl_support_method              = "sni-only"
        minimum_protocol_version        = "TLSv1.2_2021"
    }

}

output "CF_ARN" {
    value                               = aws_cloudfront_distribution.site-host-distro.arn
}