mock_provider "aws" {}

# ---------------------------------------------------------------------------
# Shared variables reused across all runs
# ---------------------------------------------------------------------------
variables {
  env               = "Dev"
  userDefinedString = "myapp"
  tags              = { environment = "test" }
  bucket            = {}
}

# ---------------------------------------------------------------------------
# naming_convention
# Verifies the bucket name is generated from env + userDefinedString + sha1 unique suffix
# ---------------------------------------------------------------------------
run "naming_convention" {
  command = plan

  assert {
    condition     = length(aws_s3_bucket.this.bucket) <= 63
    error_message = "Bucket name must not exceed 63 characters"
  }

  assert {
    condition     = can(regex("^[0-9a-z-]+$", aws_s3_bucket.this.bucket))
    error_message = "Bucket name must be lowercase alphanumeric and hyphens only"
  }
}

# ---------------------------------------------------------------------------
# default_values
# Plan succeeds with an empty bucket object (all optional fields defaulted)
# ---------------------------------------------------------------------------
run "default_values" {
  command = plan

  assert {
    condition     = aws_s3_bucket_versioning.this.versioning_configuration[0].status == "Enabled"
    error_message = "Versioning must be enabled by default"
  }

  assert {
    condition     = one(aws_s3_bucket_server_side_encryption_configuration.this.rule).apply_server_side_encryption_by_default[0].sse_algorithm == "AES256"
    error_message = "Default sse_algorithm must be AES256"
  }

  assert {
    condition     = aws_s3_bucket_public_access_block.this.block_public_acls == true
    error_message = "Public ACLs must be blocked by default"
  }

  assert {
    condition     = aws_s3_bucket.this.force_destroy == false
    error_message = "force_destroy must default to false"
  }
}

# ---------------------------------------------------------------------------
# tags_are_merged_with_module_tag
# Caller-supplied tags, bucket.tags, and the module tag are all merged
# ---------------------------------------------------------------------------
run "tags_are_merged_with_module_tag" {
  command = plan

  variables {
    bucket = {
      tags = { owner = "team-x" }
    }
  }

  assert {
    condition     = aws_s3_bucket.this.tags["environment"] == "test"
    error_message = "Caller-supplied tags must be preserved"
  }

  assert {
    condition     = aws_s3_bucket.this.tags["owner"] == "team-x"
    error_message = "bucket.tags must be merged in"
  }

  assert {
    condition     = contains(keys(aws_s3_bucket.this.tags), "module")
    error_message = "module tag must be merged into tags"
  }
}

# ---------------------------------------------------------------------------
# versioning_can_be_disabled
# ---------------------------------------------------------------------------
run "versioning_can_be_disabled" {
  command = plan

  variables {
    bucket = {
      versioning_enabled = false
    }
  }

  assert {
    condition     = aws_s3_bucket_versioning.this.versioning_configuration[0].status == "Suspended"
    error_message = "Versioning must be suspended when disabled"
  }
}

# ---------------------------------------------------------------------------
# sse_kms
# kms_master_key_id is only set when sse_algorithm = "aws:kms"
# ---------------------------------------------------------------------------
run "sse_kms" {
  command = plan

  variables {
    bucket = {
      sse_algorithm = "aws:kms"
      kms_key_id    = "arn:aws:kms:ca-central-1:000000000000:key/test-key"
    }
  }

  assert {
    condition     = one(aws_s3_bucket_server_side_encryption_configuration.this.rule).apply_server_side_encryption_by_default[0].kms_master_key_id == "arn:aws:kms:ca-central-1:000000000000:key/test-key"
    error_message = "kms_master_key_id must be set when sse_algorithm is aws:kms"
  }
}

# ---------------------------------------------------------------------------
# force_destroy_enabled
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# optional_features_absent_by_default
# No advanced-feature resources are created when the bucket object is empty
# ---------------------------------------------------------------------------
run "optional_features_absent_by_default" {
  command = plan

  assert {
    condition     = length(aws_s3_bucket_ownership_controls.this) == 0
    error_message = "ownership_controls must not be created by default"
  }
  assert {
    condition     = length(aws_s3_bucket_acl.this) == 0
    error_message = "acl must not be created by default"
  }
  assert {
    condition     = length(aws_s3_bucket_policy.this) == 0
    error_message = "policy must not be created by default"
  }
  assert {
    condition     = length(aws_s3_bucket_request_payment_configuration.this) == 0
    error_message = "request_payment_configuration must not be created by default"
  }
  assert {
    condition     = length(aws_s3_bucket_accelerate_configuration.this) == 0
    error_message = "accelerate_configuration must not be created by default"
  }
  assert {
    condition     = length(aws_s3_bucket_abac.this) == 0
    error_message = "abac must not be created by default"
  }
  assert {
    condition     = length(aws_s3_bucket_lifecycle_configuration.this) == 0
    error_message = "lifecycle_configuration must not be created by default"
  }
  assert {
    condition     = length(aws_s3_bucket_website_configuration.this) == 0
    error_message = "website_configuration must not be created by default"
  }
  assert {
    condition     = length(aws_s3_bucket_cors_configuration.this) == 0
    error_message = "cors_configuration must not be created by default"
  }
  assert {
    condition     = length(aws_s3_bucket_logging.this) == 0
    error_message = "logging must not be created by default"
  }
  assert {
    condition     = length(aws_s3_bucket_notification.this) == 0
    error_message = "notification must not be created by default"
  }
  assert {
    condition     = length(aws_s3_bucket_replication_configuration.this) == 0
    error_message = "replication_configuration must not be created by default"
  }
  assert {
    condition     = length(aws_s3_bucket_analytics_configuration.this) == 0
    error_message = "analytics_configuration must not be created by default"
  }
  assert {
    condition     = length(aws_s3_bucket_intelligent_tiering_configuration.this) == 0
    error_message = "intelligent_tiering_configuration must not be created by default"
  }
  assert {
    condition     = length(aws_s3_bucket_inventory.this) == 0
    error_message = "inventory must not be created by default"
  }
  assert {
    condition     = length(aws_s3_bucket_metric.this) == 0
    error_message = "metric must not be created by default"
  }
  assert {
    condition     = length(aws_s3_bucket_metadata_configuration.this) == 0
    error_message = "metadata_configuration must not be created by default"
  }
  assert {
    condition     = length(aws_s3_bucket_object_lock_configuration.this) == 0
    error_message = "object_lock_configuration must not be created by default"
  }
}

# ---------------------------------------------------------------------------
# ownership_controls_and_acl
# ---------------------------------------------------------------------------
run "ownership_controls_and_acl" {
  command = plan

  variables {
    bucket = {
      ownership_controls = { object_ownership = "BucketOwnerPreferred" }
      acl                = "private"
    }
  }

  assert {
    condition     = aws_s3_bucket_ownership_controls.this["enabled"].rule[0].object_ownership == "BucketOwnerPreferred"
    error_message = "ownership_controls rule must be applied"
  }
  assert {
    condition     = aws_s3_bucket_acl.this["enabled"].acl == "private"
    error_message = "acl must be applied"
  }
}

# ---------------------------------------------------------------------------
# bucket_policy
# ---------------------------------------------------------------------------
run "bucket_policy" {
  command = plan

  variables {
    bucket = {
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
          Effect    = "Deny"
          Principal = "*"
          Action    = "s3:*"
          Resource  = "*"
          Condition = { Bool = { "aws:SecureTransport" = "false" } }
        }]
      })
    }
  }

  assert {
    condition     = length(aws_s3_bucket_policy.this) == 1
    error_message = "policy resource must be created when bucket.policy is set"
  }
}

# ---------------------------------------------------------------------------
# request_payer_and_accelerate
# ---------------------------------------------------------------------------
run "request_payer_and_accelerate" {
  command = plan

  variables {
    bucket = {
      request_payer     = "Requester"
      accelerate_status = "Enabled"
    }
  }

  assert {
    condition     = aws_s3_bucket_request_payment_configuration.this["enabled"].payer == "Requester"
    error_message = "request_payer must be applied"
  }
  assert {
    condition     = aws_s3_bucket_accelerate_configuration.this["enabled"].status == "Enabled"
    error_message = "accelerate_status must be applied"
  }
}

# ---------------------------------------------------------------------------
# lifecycle_rule
# ---------------------------------------------------------------------------
run "lifecycle_rule" {
  command = plan

  variables {
    bucket = {
      lifecycle_rule = [
        {
          id     = "expire-old-versions"
          status = "Enabled"
          filter = { prefix = "logs/" }
          expiration = {
            days = 90
          }
          noncurrent_version_expiration = {
            noncurrent_days = 30
          }
        }
      ]
    }
  }

  assert {
    condition     = aws_s3_bucket_lifecycle_configuration.this["enabled"].rule[0].id == "expire-old-versions"
    error_message = "lifecycle rule must be created"
  }
  assert {
    condition     = aws_s3_bucket_lifecycle_configuration.this["enabled"].rule[0].expiration[0].days == 90
    error_message = "expiration.days must be applied"
  }
}

# ---------------------------------------------------------------------------
# website_and_cors
# ---------------------------------------------------------------------------
run "website_and_cors" {
  command = plan

  variables {
    bucket = {
      website = {
        index_document = "index.html"
        error_document = "404.html"
      }
      cors_rule = [
        {
          allowed_methods = ["GET"]
          allowed_origins = ["*"]
        }
      ]
    }
  }

  assert {
    condition     = aws_s3_bucket_website_configuration.this["enabled"].index_document[0].suffix == "index.html"
    error_message = "website index_document must be applied"
  }
  assert {
    condition     = length(aws_s3_bucket_cors_configuration.this["enabled"].cors_rule) == 1
    error_message = "cors_rule must be applied"
  }
}

# ---------------------------------------------------------------------------
# logging
# ---------------------------------------------------------------------------
run "logging" {
  command = plan

  variables {
    bucket = {
      logging = {
        target_bucket = "log-bucket"
        target_prefix = "s3-logs/"
      }
    }
  }

  assert {
    condition     = aws_s3_bucket_logging.this["enabled"].target_bucket == "log-bucket"
    error_message = "logging target_bucket must be applied"
  }
}

# ---------------------------------------------------------------------------
# notification
# ---------------------------------------------------------------------------
run "notification" {
  command = plan

  variables {
    bucket = {
      notification = {
        queue = [
          {
            queue_arn = "arn:aws:sqs:ca-central-1:000000000000:test-queue"
            events    = ["s3:ObjectCreated:*"]
          }
        ]
      }
    }
  }

  assert {
    condition     = length(aws_s3_bucket_notification.this["enabled"].queue) == 1
    error_message = "notification queue must be applied"
  }
}

# ---------------------------------------------------------------------------
# replication
# ---------------------------------------------------------------------------
run "replication" {
  command = plan

  variables {
    bucket = {
      versioning_enabled = true
      replication = {
        role = "arn:aws:iam::000000000000:role/replication-role"
        rule = [
          {
            status = "Enabled"
            destination = {
              bucket = "arn:aws:s3:::destination-bucket"
            }
          }
        ]
      }
    }
  }

  assert {
    condition     = aws_s3_bucket_replication_configuration.this["enabled"].role == "arn:aws:iam::000000000000:role/replication-role"
    error_message = "replication role must be applied"
  }
}

# ---------------------------------------------------------------------------
# analytics_intelligent_tiering_inventory_metric
# ---------------------------------------------------------------------------
run "analytics_intelligent_tiering_inventory_metric" {
  command = plan

  variables {
    bucket = {
      analytics = {
        all-objects = {
          filter = { prefix = "" }
        }
      }
      intelligent_tiering = {
        archive = {
          status = "Enabled"
          tiering = [
            { access_tier = "ARCHIVE_ACCESS", days = 90 }
          ]
        }
      }
      inventory = {
        weekly = {
          included_object_versions = "Current"
          destination = {
            bucket = {
              bucket_arn = "arn:aws:s3:::inventory-bucket"
              format     = "CSV"
            }
          }
          schedule = { frequency = "Weekly" }
        }
      }
      metric = {
        entire-bucket = {}
      }
    }
  }

  assert {
    condition     = length(aws_s3_bucket_analytics_configuration.this) == 1
    error_message = "analytics_configuration must be created"
  }
  assert {
    condition     = contains([for t in aws_s3_bucket_intelligent_tiering_configuration.this["archive"].tiering : t.access_tier], "ARCHIVE_ACCESS")
    error_message = "intelligent_tiering tiering must be applied"
  }
  assert {
    condition     = aws_s3_bucket_inventory.this["weekly"].schedule[0].frequency == "Weekly"
    error_message = "inventory schedule must be applied"
  }
  assert {
    condition     = length(aws_s3_bucket_metric.this) == 1
    error_message = "metric must be created"
  }
}

# ---------------------------------------------------------------------------
# object_lock
# ---------------------------------------------------------------------------
run "object_lock" {
  command = plan

  variables {
    bucket = {
      object_lock_enabled = true
      object_lock_configuration = {
        default_retention = {
          mode = "GOVERNANCE"
          days = 30
        }
      }
    }
  }

  assert {
    condition     = aws_s3_bucket.this.object_lock_enabled == true
    error_message = "object_lock_enabled must be applied"
  }
  assert {
    condition     = aws_s3_bucket_object_lock_configuration.this["enabled"].rule[0].default_retention[0].mode == "GOVERNANCE"
    error_message = "object_lock default_retention must be applied"
  }
}
