# Object ownership, canned/custom ACLs, bucket policy, request payment and
# transfer acceleration. All optional; each resource is only created when the
# matching key is present in var.bucket.

resource "aws_s3_bucket_ownership_controls" "this" {
  for_each = try(var.bucket.ownership_controls, null) != null ? { enabled = true } : {}

  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = var.bucket.ownership_controls.object_ownership
  }
}

# ACL requires ownership_controls to allow ACLs (BucketOwnerPreferred/ObjectWriter)
# and public access block to not block it when the ACL is public - that
# validation is left to AWS/the caller, this module just passes values through.
resource "aws_s3_bucket_acl" "this" {
  for_each = try(var.bucket.acl, null) != null || try(var.bucket.access_control_policy, null) != null ? { enabled = true } : {}

  bucket = aws_s3_bucket.this.id
  acl    = try(var.bucket.acl, null)

  dynamic "access_control_policy" {
    for_each = try(var.bucket.access_control_policy, null) != null ? [var.bucket.access_control_policy] : []
    content {
      owner {
        id           = access_control_policy.value.owner.id
        display_name = try(access_control_policy.value.owner.display_name, null)
      }

      dynamic "grant" {
        for_each = try(access_control_policy.value.grant, [])
        content {
          permission = grant.value.permission
          grantee {
            type          = grant.value.grantee.type
            id            = try(grant.value.grantee.id, null)
            email_address = try(grant.value.grantee.email_address, null)
            uri           = try(grant.value.grantee.uri, null)
          }
        }
      }
    }
  }

  depends_on = [aws_s3_bucket_ownership_controls.this]
}

resource "aws_s3_bucket_policy" "this" {
  for_each = try(var.bucket.policy, null) != null ? { enabled = true } : {}

  bucket = aws_s3_bucket.this.id
  policy = var.bucket.policy
}

resource "aws_s3_bucket_request_payment_configuration" "this" {
  for_each = try(var.bucket.request_payer, null) != null ? { enabled = true } : {}

  bucket = aws_s3_bucket.this.id
  payer  = var.bucket.request_payer
}

resource "aws_s3_bucket_accelerate_configuration" "this" {
  for_each = try(var.bucket.accelerate_status, null) != null ? { enabled = true } : {}

  bucket = aws_s3_bucket.this.id
  status = var.bucket.accelerate_status
}

# Attribute-Based Access Control (tag-based access control on the bucket)
resource "aws_s3_bucket_abac" "this" {
  for_each = try(var.bucket.abac_status, null) != null ? { enabled = true } : {}

  bucket = aws_s3_bucket.this.id
  abac_status {
    status = var.bucket.abac_status
  }
}
