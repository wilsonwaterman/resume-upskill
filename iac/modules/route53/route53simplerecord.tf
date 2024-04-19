variable "ROUTE53_HOSTED_ZONE_ID" {
}

variable "SITE_DOMAIN" {
}

variable "DISTRO_DOMAIN_NAME" {
}

variable "CF_HOSTED_ZONE_ID" {
}

resource "aws_route53_record" "www-record" {
    zone_id                     = var.ROUTE53_HOSTED_ZONE_ID
    name                        = var.SITE_DOMAIN
    type                        = "A"

    alias {
        name                    = var.DISTRO_DOMAIN_NAME
        zone_id                 = var.CF_HOSTED_ZONE_ID
        evaluate_target_health  = false
    }
}