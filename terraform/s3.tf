
resource "aws_s3_bucket" "www" {
    bucket_prefix = "www"
}

resource "aws_s3_bucket_acl" "www" {
    bucket = aws_s3_bucket.www.id
    acl = "private"
}

resource "aws_s3_bucket_policy" "main" {
    bucket = aws_s3_bucket.www.id
    policy = jsonencode({
        "Version": "2008-10-17",
        "Statement": [{
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudfront.amazonaws.com"
            },
            "Action": "s3:GetObject",
            "Resource": "${aws_s3_bucket.www.arn}/*"
            "Condition": {
                "StringEquals": {
                    "aws:SourceArn": aws_cloudfront_distribution.static-www.arn
                }
            }
        }]
    })
}

locals {
    mime_types = jsondecode(file("${path.module}/mime.json"))
}

resource "aws_s3_object" "web" {
    for_each = fileset("${path.cwd}/charts/", "**")
    bucket = aws_s3_bucket.www.id
    key = each.value
    content_type = lookup(local.mime_types, regex("\\.[^.]+$", each.value), null)
    source = "${path.cwd}/charts/${each.value}"
    etag = filemd5("${path.cwd}/charts/${each.value}")
}

