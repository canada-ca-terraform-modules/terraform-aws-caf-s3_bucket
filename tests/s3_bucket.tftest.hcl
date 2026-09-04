# tests/s3_bucket.tftest.hcl
mock_provider "aws" {}

variables {
  env               = "Dev"
  userDefinedString = "test"
  tags              = { environment = "test" }
}

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
}

run "tags_are_merged_with_module_tag" {
  command = plan

  assert {
    condition     = aws_s3_bucket.this.tags["environment"] == "test"
    error_message = "Caller-supplied tags must be preserved"
  }

  assert {
    condition     = contains(keys(aws_s3_bucket.this.tags), "module")
    error_message = "module tag must be merged into tags"
  }
}

run "versioning_can_be_disabled" {
  command = plan
  variables {
    versioning_enabled = false
  }

  assert {
    condition     = aws_s3_bucket_versioning.this.versioning_configuration[0].status == "Suspended"
    error_message = "Versioning must be suspended when disabled"
  }
}
