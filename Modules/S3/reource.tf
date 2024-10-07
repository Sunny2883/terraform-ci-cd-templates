

# Define the S3 bucket
resource "aws_s3_bucket" "terraformtemplatebucket" {
  bucket = "terraform-template-bucket"

  tags = {
    Name = "Template Bucket"
  }
}

# Enforce Object Ownership using aws_s3_bucket_ownership_controls
resource "aws_s3_bucket_ownership_controls" "terraformtemplatebucket" {
  bucket = aws_s3_bucket.terraformtemplatebucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Enable website hosting using the aws_s3_bucket_website_configuration resource
resource "aws_s3_bucket_website_configuration" "terraform-template-bucket-configuration" {
  bucket = aws_s3_bucket.terraformtemplatebucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Disable block public access settings
resource "aws_s3_bucket_public_access_block" "terraform-template-bucket-access-block" {
  bucket = aws_s3_bucket.terraformtemplatebucket.id

  block_public_acls   = false
  ignore_public_acls  = false
  block_public_policy = false
  restrict_public_buckets = false
}

# Define the S3 bucket policy to allow public read access
resource "aws_s3_bucket_policy" "terraform-template-bucket-policy" {
  bucket = aws_s3_bucket.terraformtemplatebucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action   = "s3:GetObject"
        Resource = "arn:aws:s3:::${aws_s3_bucket.terraformtemplatebucket.bucket}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.terraform-template-bucket-access-block]
}