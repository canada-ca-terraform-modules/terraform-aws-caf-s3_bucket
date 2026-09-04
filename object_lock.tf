# Object Lock default retention (bucket must have object_lock_enabled = true,
# see var.bucket.object_lock_enabled in module.tf).

resource "aws_s3_bucket_object_lock_configuration" "this" {
  for_each = try(var.bucket.object_lock_configuration, null) != null ? { enabled = true } : {}

  bucket = aws_s3_bucket.this.id

  dynamic "rule" {
    for_each = try(var.bucket.object_lock_configuration.default_retention, null) != null ? [1] : []
    content {
      default_retention {
        mode  = var.bucket.object_lock_configuration.default_retention.mode
        days  = try(var.bucket.object_lock_configuration.default_retention.days, null)
        years = try(var.bucket.object_lock_configuration.default_retention.years, null)
      }
    }
  }
}
