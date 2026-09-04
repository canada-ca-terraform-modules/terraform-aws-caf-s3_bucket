# Cross-region/same-region replication. Requires versioning to be enabled on
# both source and destination buckets (enforced by AWS, not by this module).

resource "aws_s3_bucket_replication_configuration" "this" {
  for_each = try(var.bucket.replication, null) != null ? { enabled = true } : {}

  bucket = aws_s3_bucket.this.id
  role   = var.bucket.replication.role

  dynamic "rule" {
    for_each = var.bucket.replication.rule
    content {
      id       = try(rule.value.id, null)
      status   = try(rule.value.status, "Enabled")
      priority = try(rule.value.priority, null)
      prefix   = try(rule.value.prefix, null)

      destination {
        bucket        = rule.value.destination.bucket
        storage_class = try(rule.value.destination.storage_class, null)
        account       = try(rule.value.destination.account, null)

        dynamic "access_control_translation" {
          for_each = try(rule.value.destination.access_control_translation, null) != null ? [rule.value.destination.access_control_translation] : []
          content {
            owner = access_control_translation.value.owner
          }
        }

        dynamic "encryption_configuration" {
          for_each = try(rule.value.destination.encryption_configuration, null) != null ? [rule.value.destination.encryption_configuration] : []
          content {
            replica_kms_key_id = encryption_configuration.value.replica_kms_key_id
          }
        }

        dynamic "metrics" {
          for_each = try(rule.value.destination.metrics, null) != null ? [rule.value.destination.metrics] : []
          content {
            status = metrics.value.status
            dynamic "event_threshold" {
              for_each = try(metrics.value.event_threshold, null) != null ? [metrics.value.event_threshold] : []
              content {
                minutes = event_threshold.value.minutes
              }
            }
          }
        }

        dynamic "replication_time" {
          for_each = try(rule.value.destination.replication_time, null) != null ? [rule.value.destination.replication_time] : []
          content {
            status = replication_time.value.status
            time {
              minutes = replication_time.value.time.minutes
            }
          }
        }
      }

      dynamic "delete_marker_replication" {
        for_each = try(rule.value.delete_marker_replication, null) != null ? [rule.value.delete_marker_replication] : []
        content {
          status = delete_marker_replication.value.status
        }
      }

      dynamic "existing_object_replication" {
        for_each = try(rule.value.existing_object_replication, null) != null ? [rule.value.existing_object_replication] : []
        content {
          status = existing_object_replication.value.status
        }
      }

      dynamic "filter" {
        for_each = try(rule.value.filter, null) != null ? [rule.value.filter] : []
        content {
          prefix = try(filter.value.prefix, null)

          dynamic "and" {
            for_each = try(filter.value.and, null) != null ? [filter.value.and] : []
            content {
              prefix = try(and.value.prefix, null)
              tags   = try(and.value.tags, null)
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

      dynamic "source_selection_criteria" {
        for_each = try(rule.value.source_selection_criteria, null) != null ? [rule.value.source_selection_criteria] : []
        content {
          dynamic "replica_modifications" {
            for_each = try(source_selection_criteria.value.replica_modifications, null) != null ? [source_selection_criteria.value.replica_modifications] : []
            content {
              status = replica_modifications.value.status
            }
          }
          dynamic "sse_kms_encrypted_objects" {
            for_each = try(source_selection_criteria.value.sse_kms_encrypted_objects, null) != null ? [source_selection_criteria.value.sse_kms_encrypted_objects] : []
            content {
              status = sse_kms_encrypted_objects.value.status
            }
          }
        }
      }
    }
  }

  depends_on = [aws_s3_bucket_versioning.this]
}
