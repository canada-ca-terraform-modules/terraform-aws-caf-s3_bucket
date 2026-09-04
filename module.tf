resource "aws_s3_bucket" "this" {
  bucket        = local.bucket-name
  force_destroy = try(var.bucket.force_destroy, false)

  # Tags - Merging tags provided by ESLZ with tags provided by the user
  tags = merge(var.tags, try(var.bucket.tags, {}), local.module_tag)
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = try(var.bucket.versioning_enabled, true) ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = try(var.bucket.sse_algorithm, "AES256")
      kms_master_key_id = try(var.bucket.sse_algorithm, "AES256") == "aws:kms" ? try(var.bucket.kms_key_id, null) : null
    }
    bucket_key_enabled = try(var.bucket.bucket_key_enabled, true)
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = try(var.bucket.block_public_acls, true)
  block_public_policy     = try(var.bucket.block_public_policy, true)
  ignore_public_acls      = try(var.bucket.ignore_public_acls, true)
  restrict_public_buckets = try(var.bucket.restrict_public_buckets, true)
}
