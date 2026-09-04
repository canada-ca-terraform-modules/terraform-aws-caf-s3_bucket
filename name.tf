## Variables responsible for formatting the name of the bucket using the userDefinedString input variable
## unique_8 is needed to ensure that bucket names are globally unique across all AWS accounts
locals {
  # ponytail: uniqueness derived from env+userDefinedString only (no account/region
  # salt). If this collides, add data.aws_caller_identity/region into the hash input.
  unique_8       = substr(sha1("${var.env}-${var.userDefinedString}"), 0, 8)
  bucket-regex   = "/[^0-9a-z-]/" # S3 bucket names allow only lowercase, digits and hyphens
  env-compliant  = replace(lower(var.env), local.bucket-regex, "")
  name-compliant = replace(lower(var.userDefinedString), local.bucket-regex, "")
  bucket-name    = substr("${local.env-compliant}-${local.name-compliant}-${local.unique_8}", 0, 63)
}
