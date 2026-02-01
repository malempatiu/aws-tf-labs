# Create a bucket
resource "aws_s3_bucket" "static_site" {
  bucket = var.bucket_name

  tags = {
    "project"     = "TF Static Host"
    "Environment" = "DEV"
    "Owner"       = "malempati"
  }
}

# Create objects in the bucket
resource "aws_s3_object" "website_files" {
  for_each = fileset("${path.module}/website", "**/*")

  bucket = aws_s3_bucket.static_site.id
  key    = each.value
  source = "${path.module}/website/${each.value}"

  etag = filemd5("${path.module}/website/${each.value}")

  content_type = lookup(
    {
      html = "text/html"
      css  = "text/css"
      js   = "application/javascript"
    },
    lower(regex("\\.([^.]+)$", each.value)[0]),
    "application/octet-stream"
  )
}

# making bucket completely private and only allowed through OAC(Origin Access Control)
resource "aws_s3_bucket_public_access_block" "bucket_blocks" {
  bucket = aws_s3_bucket.static_site.id

  block_public_acls       = true # S3 → Bucket → Permissions → Block public access (bucket settings)
  block_public_policy     = true # Prevents adding bucket policies that grant public access
  ignore_public_acls      = true # Existing public ACLs are ignored and Objects with public ACLs will not be publicly accessible
  restrict_public_buckets = true # Even if a bucket policy allows public access, access is restricted
}

# Secure bucket with OAC
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "S3 Origin OAC"
  description                       = "Securing S3 Origin"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

locals {
  s3_origin_id = "S3-${aws_s3_bucket.static_site.id}"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.static_site.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

# Bucket Policy for CDN
resource "aws_s3_bucket_policy" "allow_access_from_cdn" {
  bucket     = aws_s3_bucket.static_site.id
  depends_on = [aws_s3_bucket_public_access_block.bucket_blocks]
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowCloudFrontServicePrincipalReadOnly",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cloudfront.amazonaws.com"
        },
        "Action" : "s3:GetObject",
        "Resource" : "${aws_s3_bucket.static_site.arn}/*",
        "Condition" : {
          "StringEquals" : {
            "AWS:SourceArn" : aws_cloudfront_distribution.s3_distribution.arn
          }
        }
      }
    ]
  })
}





