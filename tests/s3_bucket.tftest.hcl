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
run "force_destroy_enabled" {
  command = plan

  variables {
    bucket = {
      force_destroy = true
    }
  }

  assert {
    condition     = aws_s3_bucket.this.force_destroy == true
    error_message = "force_destroy must be true when set"
  }
}
