variable "tags" {
  description = "Tags to be applied to the S3 bucket to be created"
  type        = map(string)
}

variable "env" {
  description = "(Required) env value"
  type        = string
}

variable "userDefinedString" {
  description = "UserDefinedString part of the name of the resource"
  type        = string
}

variable "force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error."
  type        = bool
  default     = false
}

variable "versioning_enabled" {
  description = "Enable versioning on the bucket."
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "Server-side encryption algorithm. Valid values are AES256 and aws:kms."
  type        = string
  default     = "AES256"
}

variable "kms_key_id" {
  description = "AWS KMS master key ID used for SSE-KMS encryption. Required when sse_algorithm is aws:kms."
  type        = string
  default     = null
}

variable "bucket_key_enabled" {
  description = "Whether to use Amazon S3 Bucket Keys for SSE-KMS."
  type        = bool
  default     = true
}

variable "block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket."
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Whether Amazon S3 should block public bucket policies for this bucket."
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for this bucket."
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket."
  type        = bool
  default     = true
}
