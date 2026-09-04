s3buckets = {
  example01 = {                   # Key defines the userDefinedString
    versioning_enabled = true     # Optional: Default: true
    sse_algorithm      = "AES256" # Optional: Possible values: AES256, aws:kms. Default: AES256

    # kms_key_id                = "<kms-key-arn>" # Required when sse_algorithm = "aws:kms"
    # bucket_key_enabled        = true            # Optional: Default: true
    # blocked_encryption_types  = ["aws:kms"]      # Optional: deny-list of encryption types
    # force_destroy             = false            # Optional: Default: false
    # block_public_acls         = true             # Optional: Default: true
    # block_public_policy       = true             # Optional: Default: true
    # ignore_public_acls        = true             # Optional: Default: true
    # restrict_public_buckets   = true             # Optional: Default: true
    # skip_destroy              = false            # Optional: keep public access block on destroy
    # tags = {                                     # Optional: merged with ESLZ-level tags
    #   owner = "team-x"
    # }

    # Optional: Object ownership (needed before an ACL can be set)
    # ownership_controls = {
    #   object_ownership = "BucketOwnerPreferred" # Required: BucketOwnerPreferred, BucketOwnerEnforced, ObjectWriter
    # }

    # Optional: Canned ACL (requires ownership_controls above, mutually exclusive with access_control_policy)
    # acl = "private"

    # Optional: Custom grants instead of a canned ACL
    # access_control_policy = {
    #   owner = { id = "<canonical-user-id>" }
    #   grant = [
    #     {
    #       permission = "READ" # Required: FULL_CONTROL, WRITE, WRITE_ACP, READ, READ_ACP
    #       grantee = {
    #         type = "CanonicalUser" # Required: CanonicalUser, AmazonCustomerByEmail, Group
    #         id   = "<canonical-user-id>"
    #       }
    #     }
    #   ]
    # }

    # Optional: Bucket policy (JSON string, e.g. jsonencode({...}))
    # policy = jsonencode({
    #   Version = "2012-10-17"
    #   Statement = [
    #     {
    #       Sid       = "DenyInsecureTransport"
    #       Effect    = "Deny"
    #       Principal = "*"
    #       Action    = "s3:*"
    #       Resource  = ["arn:aws:s3:::example-bucket", "arn:aws:s3:::example-bucket/*"]
    #       Condition = { Bool = { "aws:SecureTransport" = "false" } }
    #     }
    #   ]
    # })

    # Optional: Who pays for requests/data transfer
    # request_payer = "BucketOwner" # Possible values: BucketOwner, Requester

    # Optional: Transfer acceleration
    # accelerate_status = "Enabled" # Possible values: Enabled, Suspended

    # Optional: Attribute-based access control
    # abac_status = "Enabled" # Possible values: Enabled, Disabled

    # Optional: Object Lock default retention (requires object_lock_enabled = true, forces new resource)
    # object_lock_enabled = true
    # object_lock_configuration = {
    #   default_retention = {
    #     mode  = "GOVERNANCE" # Required: GOVERNANCE, COMPLIANCE
    #     days  = 30           # One of days or years is required
    #     years = null
    #   }
    # }

    # Optional: Lifecycle rules
    # lifecycle_rule = [
    #   {
    #     id     = "expire-noncurrent"
    #     status = "Enabled" # Enabled, Disabled
    #     filter = { prefix = "logs/" }
    #     transition = [
    #       { days = 30, storage_class = "STANDARD_IA" },
    #       { days = 90, storage_class = "GLACIER" }
    #     ]
    #     expiration = {
    #       days = 365
    #     }
    #     noncurrent_version_expiration = {
    #       noncurrent_days = 30
    #     }
    #     abort_incomplete_multipart_upload = {
    #       days_after_initiation = 7
    #     }
    #   }
    # ]
    # transition_default_minimum_object_size = "all_storage_classes_128K" # Optional

    # Optional: Static website hosting
    # website = {
    #   index_document = "index.html" # Optional
    #   error_document = "404.html"   # Optional
    #   # redirect_all_requests_to = { host_name = "example.com", protocol = "https" }
    #   # routing_rule = [
    #   #   {
    #   #     condition = { key_prefix_equals = "docs/" }
    #   #     redirect  = { replace_key_prefix_with = "documents/" }
    #   #   }
    #   # ]
    # }

    # Optional: CORS rules
    # cors_rule = [
    #   {
    #     allowed_headers = ["*"]
    #     allowed_methods = ["GET", "HEAD"]
    #     allowed_origins = ["https://example.com"]
    #     expose_headers  = ["ETag"]
    #     max_age_seconds = 3600
    #   }
    # ]

    # Optional: Access logging to another bucket
    # logging = {
    #   target_bucket = "log-bucket-name"
    #   target_prefix = "s3-access-logs/example01/"
    # }

    # Optional: Event notifications
    # notification = {
    #   eventbridge = true # Optional: forward all events to EventBridge
    #   queue = [
    #     {
    #       queue_arn = "arn:aws:sqs:ca-central-1:000000000000:example-queue"
    #       events    = ["s3:ObjectCreated:*"]
    #     }
    #   ]
    #   # lambda_function = [{ lambda_function_arn = "...", events = ["s3:ObjectRemoved:*"] }]
    #   # topic           = [{ topic_arn = "...", events = ["s3:ObjectCreated:*"] }]
    # }

    # Optional: Cross-region/same-region replication (requires versioning_enabled = true)
    # replication = {
    #   role = "arn:aws:iam::000000000000:role/s3-replication-role"
    #   rule = [
    #     {
    #       status = "Enabled"
    #       destination = {
    #         bucket        = "arn:aws:s3:::destination-bucket"
    #         storage_class = "STANDARD"
    #       }
    #     }
    #   ]
    # }

    # Optional: Storage class analytics (map keyed by config name)
    # analytics = {
    #   all-objects = {
    #     filter = { prefix = "" }
    #   }
    # }

    # Optional: S3 Intelligent-Tiering configurations (map keyed by config name)
    # intelligent_tiering = {
    #   archive-tier = {
    #     status = "Enabled"
    #     tiering = [
    #       { access_tier = "ARCHIVE_ACCESS", days = 90 },
    #       { access_tier = "DEEP_ARCHIVE_ACCESS", days = 180 }
    #     ]
    #   }
    # }

    # Optional: Inventory reports (map keyed by config name)
    # inventory = {
    #   weekly = {
    #     included_object_versions = "Current" # Current, All
    #     destination = {
    #       bucket = {
    #         bucket_arn = "arn:aws:s3:::inventory-bucket"
    #         format     = "CSV" # CSV, ORC, Parquet
    #       }
    #     }
    #     schedule = { frequency = "Weekly" } # Daily, Weekly
    #   }
    # }

    # Optional: Request metrics (map keyed by config name)
    # metric = {
    #   entire-bucket = {}
    # }

    # Optional: S3 Metadata tables (journal/inventory tables backed by S3 Tables)
    # metadata_configuration = {
    #   journal_table_configuration = {
    #     record_expiration = { expiration = "ENABLED", days = 90 }
    #   }
    #   inventory_table_configuration = {
    #     configuration_state = "ENABLED"
    #   }
    # }
  }
}
