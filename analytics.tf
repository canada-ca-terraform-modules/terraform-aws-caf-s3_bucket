# Storage analytics, intelligent-tiering, inventory reports and request
# metrics. Each accepts a map keyed by the configuration name so multiple
# configurations of the same type can be declared per bucket.

resource "aws_s3_bucket_analytics_configuration" "this" {
  for_each = try(var.bucket.analytics, {})

  bucket = aws_s3_bucket.this.id
  name   = each.key

  dynamic "filter" {
    for_each = try(each.value.filter, null) != null ? [each.value.filter] : []
    content {
      prefix = try(filter.value.prefix, null)
      tags   = try(filter.value.tags, null)
    }
  }

  dynamic "storage_class_analysis" {
    for_each = try(each.value.storage_class_analysis, null) != null ? [each.value.storage_class_analysis] : []
    content {
      dynamic "data_export" {
        for_each = try(storage_class_analysis.value.data_export, null) != null ? [storage_class_analysis.value.data_export] : []
        content {
          output_schema_version = try(data_export.value.output_schema_version, "V_1")
          destination {
            s3_bucket_destination {
              bucket_arn        = data_export.value.destination.s3_bucket_destination.bucket_arn
              bucket_account_id = try(data_export.value.destination.s3_bucket_destination.bucket_account_id, null)
              format            = try(data_export.value.destination.s3_bucket_destination.format, null)
              prefix            = try(data_export.value.destination.s3_bucket_destination.prefix, null)
            }
          }
        }
      }
    }
  }
}

resource "aws_s3_bucket_intelligent_tiering_configuration" "this" {
  for_each = try(var.bucket.intelligent_tiering, {})

  bucket = aws_s3_bucket.this.id
  name   = each.key
  status = try(each.value.status, null)

  dynamic "filter" {
    for_each = try(each.value.filter, null) != null ? [each.value.filter] : []
    content {
      prefix = try(filter.value.prefix, null)
      tags   = try(filter.value.tags, null)
    }
  }

  dynamic "tiering" {
    for_each = each.value.tiering
    content {
      access_tier = tiering.value.access_tier
      days        = tiering.value.days
    }
  }
}

resource "aws_s3_bucket_inventory" "this" {
  for_each = try(var.bucket.inventory, {})

  bucket                   = aws_s3_bucket.this.id
  name                     = each.key
  enabled                  = try(each.value.enabled, true)
  included_object_versions = each.value.included_object_versions
  optional_fields          = try(each.value.optional_fields, null)

  destination {
    bucket {
      bucket_arn = each.value.destination.bucket.bucket_arn
      account_id = try(each.value.destination.bucket.account_id, null)
      format     = each.value.destination.bucket.format
      prefix     = try(each.value.destination.bucket.prefix, null)

      dynamic "encryption" {
        for_each = try(each.value.destination.bucket.encryption, null) != null ? [each.value.destination.bucket.encryption] : []
        content {
          dynamic "sse_kms" {
            for_each = try(encryption.value.sse_kms, null) != null ? [encryption.value.sse_kms] : []
            content {
              key_id = sse_kms.value.key_id
            }
          }
          dynamic "sse_s3" {
            for_each = try(encryption.value.sse_s3, false) ? [1] : []
            content {}
          }
        }
      }
    }
  }

  dynamic "filter" {
    for_each = try(each.value.filter, null) != null ? [each.value.filter] : []
    content {
      prefix = try(filter.value.prefix, null)
    }
  }

  schedule {
    frequency = each.value.schedule.frequency
  }
}

resource "aws_s3_bucket_metric" "this" {
  for_each = try(var.bucket.metric, {})

  bucket = aws_s3_bucket.this.id
  name   = each.key

  dynamic "filter" {
    for_each = try(each.value.filter, null) != null ? [each.value.filter] : []
    content {
      prefix       = try(filter.value.prefix, null)
      tags         = try(filter.value.tags, null)
      access_point = try(filter.value.access_point, null)
    }
  }
}
