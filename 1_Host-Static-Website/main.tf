resource "aws_s3_bucket" "static_host_bucket" {
  bucket = var.bucket_name

  tags = {
    "project"     = "TF Static Host"
    "Environment" = "DEV"
    "Owner"       = "malempati"
  }
}

resource "aws_s3_bucket_public_access_block" "bucket_blocks" {
  bucket = aws_s3_bucket.static_host_bucket.id

  block_public_acls       = true # S3 → Bucket → Permissions → Block public access (bucket settings)
  block_public_policy     = true # Prevents adding bucket policies that grant public access
  ignore_public_acls      = true # Existing public ACLs are ignored and Objects with public ACLs will not be publicly accessible
  restrict_public_buckets = true # Even if a bucket policy allows public access, access is restricted
}