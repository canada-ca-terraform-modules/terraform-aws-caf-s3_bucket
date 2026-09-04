locals {
  module_tag = {
    "module" = basename(abspath(path.module))
  }
  tags = merge(var.tags, local.module_tag)

  # ponytail: uniqueness derived from env+userDefinedString only (no account/region
  # salt). S3 bucket names are globally unique across all AWS accounts; if this
  # collides, add data.aws_caller_identity/region into the hash input.
  bucket-regex   = "/[^0-9a-z-]/" # S3 bucket names allow only lowercase, digits and hyphens
  unique_8       = substr(sha1("${var.env}-${var.userDefinedString}"), 0, 8)
  env-compliant  = replace(lower(var.env), local.bucket-regex, "")
  name-compliant = replace(lower(var.userDefinedString), local.bucket-regex, "")
  bucket-name    = substr("${local.env-compliant}-${local.name-compliant}-${local.unique_8}", 0, 63)
}

resource "aws_s3_bucket" "this" {
  bucket        = local.bucket-name
  force_destroy = var.force_destroy
  tags          = local.tags
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.sse_algorithm
      kms_master_key_id = var.sse_algorithm == "aws:kms" ? var.kms_key_id : null
    }
    bucket_key_enabled = var.bucket_key_enabled
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}
