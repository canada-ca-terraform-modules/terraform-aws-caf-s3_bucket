s3buckets = {
  example01 = {                   # Key defines the userDefinedString
    versioning_enabled = true     # Optional: Default: true
    sse_algorithm      = "AES256" # Optional: Possible values: AES256, aws:kms. Default: AES256

    # kms_key_id              = "<kms-key-arn>" # Required when sse_algorithm = "aws:kms"
    # bucket_key_enabled      = true            # Optional: Default: true
    # force_destroy           = false           # Optional: Default: false
    # block_public_acls       = true            # Optional: Default: true
    # block_public_policy     = true            # Optional: Default: true
    # ignore_public_acls      = true            # Optional: Default: true
    # restrict_public_buckets = true            # Optional: Default: true
    # tags = {                                  # Optional: merged with ESLZ-level tags
    #   owner = "team-x"
    # }
  }
}
