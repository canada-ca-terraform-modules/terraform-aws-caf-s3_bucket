# S3 Metadata configuration (journal and inventory tables backed by S3 Tables).

resource "aws_s3_bucket_metadata_configuration" "this" {
  for_each = try(var.bucket.metadata_configuration, null) != null ? { enabled = true } : {}

  bucket = aws_s3_bucket.this.id

  metadata_configuration {

    dynamic "inventory_table_configuration" {
      for_each = try(var.bucket.metadata_configuration.inventory_table_configuration, null) != null ? [var.bucket.metadata_configuration.inventory_table_configuration] : []
      content {
        configuration_state = try(inventory_table_configuration.value.configuration_state, "ENABLED")

        dynamic "encryption_configuration" {
          for_each = try(inventory_table_configuration.value.encryption_configuration, null) != null ? [inventory_table_configuration.value.encryption_configuration] : []
          content {
            sse_algorithm = encryption_configuration.value.sse_algorithm
            kms_key_arn   = try(encryption_configuration.value.kms_key_arn, null)
          }
        }
      }
    }

    dynamic "journal_table_configuration" {
      for_each = try(var.bucket.metadata_configuration.journal_table_configuration, null) != null ? [var.bucket.metadata_configuration.journal_table_configuration] : []
      content {
        dynamic "encryption_configuration" {
          for_each = try(journal_table_configuration.value.encryption_configuration, null) != null ? [journal_table_configuration.value.encryption_configuration] : []
          content {
            sse_algorithm = encryption_configuration.value.sse_algorithm
            kms_key_arn   = try(encryption_configuration.value.kms_key_arn, null)
          }
        }

        dynamic "record_expiration" {
          for_each = try(journal_table_configuration.value.record_expiration, null) != null ? [journal_table_configuration.value.record_expiration] : []
          content {
            expiration = record_expiration.value.expiration
            days       = try(record_expiration.value.days, null)
          }
        }
      }
    }
  }
}
