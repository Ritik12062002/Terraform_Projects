# Create S3 Bucket

resource "aws_s3_bucket" "firstbucket" {
  bucket = var.bucket_name
  tags = var.tags
}

#Make Bucket Private

resource "aws_s3_bucket_public_access_block" "s3_public_access_block" {
  bucket = aws_s3_bucket.firstbucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


# Create Origin Access Control (OAC) for S3

resource "aws_cloudfront_origin_access_control" "s3_oac" {
  name = "s3-oac"
  description = "Origin Access Control for S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior = "always"
  signing_protocol = "sigv4"
}


# Create Bucket Policy (CloudFront OAC -> S3)

resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.firstbucket.id

  # Note: avoid referencing aws_cloudfront_distribution here to prevent a dependency cycle.
  depends_on = [aws_s3_bucket_public_access_block.s3_public_access_block]

  policy = jsonencode({
    Version = "2012-10-17"
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontOAC"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action = "s3:GetObject"
        Resource = "${aws_s3_bucket.firstbucket.arn}/*"
      }
    ]
  })
}

resource "aws_s3_object" "website_files" {
  for_each = fileset("${path.module}/www", "**/*")
  bucket = aws_s3_bucket.firstbucket.id
  key = each.value
  source = "${path.module}/www/${each.value}"
  content_type = lookup(local.content_type, split(".", each.value)[length(split(".", each.value)) - 1], "application/octet-stream")
  etag = filemd5("${path.module}/www/${each.value}")

  depends_on = [ aws_s3_bucket_public_access_block.s3_public_access_block ]

}

# Create CloudFront Distribution
resource "aws_cloudfront_distribution" "website_distribution" {
  origin {
    domain_name            = aws_s3_bucket.firstbucket.bucket_regional_domain_name
    origin_id              = "myS3Origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_oac.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for static website"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "myS3Origin"

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
    compress               = true
  }

  
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = var.tags

  depends_on = [
    aws_s3_bucket_policy.website_bucket_policy,
    aws_s3_object.website_files
  ]
}


