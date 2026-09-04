# Core bucket + the "always relevant" configuration resources that ship with
# every bucket regardless of feature usage (versioning, encryption, public
# access block). Optional/advanced features live in their own files:
# access.tf, lifecycle.tf, website.tf, notification.tf, replication.tf,
# analytics.tf and metadata.tf.

resource "aws_s3_bucket" "this" {
  bucket              = local.bucket-name
  force_destroy       = try(var.bucket.force_destroy, false)
  object_lock_enabled = try(var.bucket.object_lock_enabled, null)

  # Tags - Merging tags provided by ESLZ with tags provided by the user
  tags = merge(var.tags, try(var.bucket.tags, {}), local.module_tag)
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status     = try(var.bucket.versioning_enabled, true) ? "Enabled" : "Suspended"
    mfa_delete = try(var.bucket.mfa_delete, null) != null ? (var.bucket.mfa_delete ? "Enabled" : "Disabled") : null
  }
  mfa = try(var.bucket.mfa, null)
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = try(var.bucket.sse_algorithm, "AES256")
      kms_master_key_id = try(var.bucket.sse_algorithm, "AES256") == "aws:kms" ? try(var.bucket.kms_key_id, null) : null
    }
    bucket_key_enabled       = try(var.bucket.bucket_key_enabled, true)
    blocked_encryption_types = try(var.bucket.blocked_encryption_types, null)
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = try(var.bucket.block_public_acls, true)
  block_public_policy     = try(var.bucket.block_public_policy, true)
  ignore_public_acls      = try(var.bucket.ignore_public_acls, true)
  restrict_public_buckets = try(var.bucket.restrict_public_buckets, true)
  skip_destroy            = try(var.bucket.skip_destroy, null)
}
