resource "aws_cloudfront_origin_access_identity" "default" {
  comment = "MyCloudFrontOriginAccessIdentity"
}



resource "aws_cloudfront_distribution" "cloudfront" {
  web_acl_id = var.web-acl-arn
  origin {
    domain_name = var.s3-domain-name
    origin_id   = var.s3-id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.default.cloudfront_access_identity_path
    }
  }

  enabled             = true
  default_root_object = "index.html"
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = var.s3-id
    viewer_protocol_policy = "allow-all"
    forwarded_values {
      query_string = false
      headers      = ["Origin", "Access-Control-Request-Headers", "Access-Control-Request-Method"]
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
  retain_on_delete = true
}

# data "aws_iam_policy_document" "s3_policy" {
#   statement {
#     actions   = ["s3:GetObject"]
#     resources = ["${aws_s3_bucket.fin-test.arn}/*"]
#     effect    = "Allow"
#     principals {
#       identifiers = ["*"]
#       type        = "*"
#     }
#   }
#   statement {
#     actions   = ["s3:GetObject"]
#     resources = ["${aws_s3_bucket.fin-test.arn}/*"]
#     principals {
#       identifiers = [aws_cloudfront_origin_access_identity.default.iam_arn]
#       type        = "AWS"
#     }
#   }
# }
