# Lifecycle rules (transitions, expirations, noncurrent version handling).
# var.bucket.lifecycle_rule is a list of rule objects matching the
# aws_s3_bucket_lifecycle_configuration "rule" block schema.

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  for_each = length(try(var.bucket.lifecycle_rule, [])) > 0 ? { enabled = true } : {}

  bucket                                 = aws_s3_bucket.this.id
  transition_default_minimum_object_size = try(var.bucket.transition_default_minimum_object_size, null)

  dynamic "rule" {
    for_each = var.bucket.lifecycle_rule
    content {
      id     = rule.value.id
      status = try(rule.value.status, "Enabled")
      prefix = try(rule.value.prefix, null)

      dynamic "filter" {
        for_each = try(rule.value.filter, null) != null ? [rule.value.filter] : []
        content {
          prefix                   = try(filter.value.prefix, null)
          object_size_greater_than = try(filter.value.object_size_greater_than, null)
          object_size_less_than    = try(filter.value.object_size_less_than, null)

          dynamic "and" {
            for_each = try(filter.value.and, null) != null ? [filter.value.and] : []
            content {
              prefix                   = try(and.value.prefix, null)
              tags                     = try(and.value.tags, null)
              object_size_greater_than = try(and.value.object_size_greater_than, null)
              object_size_less_than    = try(and.value.object_size_less_than, null)
            }
          }

          dynamic "tag" {
            for_each = try(filter.value.tag, null) != null ? [filter.value.tag] : []
            content {
              key   = tag.value.key
              value = tag.value.value
            }
          }
        }
      }

      dynamic "abort_incomplete_multipart_upload" {
        for_each = try(rule.value.abort_incomplete_multipart_upload, null) != null ? [rule.value.abort_incomplete_multipart_upload] : []
        content {
          days_after_initiation = try(abort_incomplete_multipart_upload.value.days_after_initiation, null)
        }
      }

      dynamic "expiration" {
        for_each = try(rule.value.expiration, null) != null ? [rule.value.expiration] : []
        content {
          date                         = try(expiration.value.date, null)
          days                         = try(expiration.value.days, null)
          expired_object_delete_marker = try(expiration.value.expired_object_delete_marker, null)
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = try(rule.value.noncurrent_version_expiration, null) != null ? [rule.value.noncurrent_version_expiration] : []
        content {
          noncurrent_days           = noncurrent_version_expiration.value.noncurrent_days
          newer_noncurrent_versions = try(noncurrent_version_expiration.value.newer_noncurrent_versions, null)
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = try(rule.value.noncurrent_version_transition, [])
        content {
          noncurrent_days           = noncurrent_version_transition.value.noncurrent_days
          storage_class             = noncurrent_version_transition.value.storage_class
          newer_noncurrent_versions = try(noncurrent_version_transition.value.newer_noncurrent_versions, null)
        }
      }

      dynamic "transition" {
        for_each = try(rule.value.transition, [])
        content {
          date          = try(transition.value.date, null)
          days          = try(transition.value.days, null)
          storage_class = transition.value.storage_class
        }
      }
    }
  }
}
