
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution
resource "aws_cloudfront_distribution" "static-www" {
    origin {
        domain_name = aws_s3_bucket.www.bucket_regional_domain_name
        origin_access_control_id = aws_cloudfront_origin_access_control.main.id
        origin_id = aws_s3_bucket.www.id
    }

    aliases = ["helmcharts.gammalab.net"]

    enabled =  true

    default_root_object = "index.html"

    default_cache_behavior {
        allowed_methods = [ "GET", "HEAD", "OPTIONS" ]
        cached_methods = [ "GET", "HEAD", "OPTIONS" ]
        target_origin_id = aws_s3_bucket.www.id

        forwarded_values {
            query_string = false

            cookies {
              forward = "none"
            }
        }

        viewer_protocol_policy = "redirect-to-https"
        min_ttl = 0
        default_ttl = 3600
        max_ttl = 86400
    }

    restrictions {
      geo_restriction {
          restriction_type = "whitelist"
          locations = [ "JP" ]
      }
    }
    viewer_certificate {
        acm_certificate_arn = var.acm_certificate_arm
        ssl_support_method = "sni-only"
    }

    custom_error_response {
        error_code = "403"
        response_code = "200"
        response_page_path = "/index.yaml"
    }
}

resource "aws_cloudfront_origin_access_control" "main" {
    name                              = "helmcharts"
    origin_access_control_origin_type = "s3"
    signing_behavior                  = "always"
    signing_protocol                  = "sigv4"
}

