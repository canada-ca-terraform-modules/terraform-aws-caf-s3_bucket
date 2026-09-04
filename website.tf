# Static website hosting, CORS rules and access logging.

resource "aws_s3_bucket_website_configuration" "this" {
  for_each = try(var.bucket.website, null) != null ? { enabled = true } : {}

  bucket        = aws_s3_bucket.this.id
  routing_rules = try(var.bucket.website.routing_rules, null)

  dynamic "index_document" {
    for_each = try(var.bucket.website.index_document, null) != null ? [1] : []
    content {
      suffix = var.bucket.website.index_document
    }
  }

  dynamic "error_document" {
    for_each = try(var.bucket.website.error_document, null) != null ? [1] : []
    content {
      key = var.bucket.website.error_document
    }
  }

  dynamic "redirect_all_requests_to" {
    for_each = try(var.bucket.website.redirect_all_requests_to, null) != null ? [var.bucket.website.redirect_all_requests_to] : []
    content {
      host_name = redirect_all_requests_to.value.host_name
      protocol  = try(redirect_all_requests_to.value.protocol, null)
    }
  }

  dynamic "routing_rule" {
    for_each = try(var.bucket.website.routing_rule, [])
    content {
      dynamic "condition" {
        for_each = try(routing_rule.value.condition, null) != null ? [routing_rule.value.condition] : []
        content {
          http_error_code_returned_equals = try(condition.value.http_error_code_returned_equals, null)
          key_prefix_equals               = try(condition.value.key_prefix_equals, null)
        }
      }
      redirect {
        host_name               = try(routing_rule.value.redirect.host_name, null)
        http_redirect_code      = try(routing_rule.value.redirect.http_redirect_code, null)
        protocol                = try(routing_rule.value.redirect.protocol, null)
        replace_key_prefix_with = try(routing_rule.value.redirect.replace_key_prefix_with, null)
        replace_key_with        = try(routing_rule.value.redirect.replace_key_with, null)
      }
    }
  }
}

resource "aws_s3_bucket_cors_configuration" "this" {
  for_each = length(try(var.bucket.cors_rule, [])) > 0 ? { enabled = true } : {}

  bucket = aws_s3_bucket.this.id

  dynamic "cors_rule" {
    for_each = var.bucket.cors_rule
    content {
      allowed_headers = try(cors_rule.value.allowed_headers, null)
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      expose_headers  = try(cors_rule.value.expose_headers, null)
      max_age_seconds = try(cors_rule.value.max_age_seconds, null)
    }
  }
}

resource "aws_s3_bucket_logging" "this" {
  for_each = try(var.bucket.logging, null) != null ? { enabled = true } : {}

  bucket        = aws_s3_bucket.this.id
  target_bucket = var.bucket.logging.target_bucket
  target_prefix = var.bucket.logging.target_prefix

  dynamic "target_grant" {
    for_each = try(var.bucket.logging.target_grant, [])
    content {
      permission = target_grant.value.permission
      grantee {
        type          = target_grant.value.grantee.type
        id            = try(target_grant.value.grantee.id, null)
        email_address = try(target_grant.value.grantee.email_address, null)
        uri           = try(target_grant.value.grantee.uri, null)
      }
    }
  }

  dynamic "target_object_key_format" {
    for_each = try(var.bucket.logging.target_object_key_format, null) != null ? [var.bucket.logging.target_object_key_format] : []
    content {
      dynamic "partitioned_prefix" {
        for_each = try(target_object_key_format.value.partition_date_source, null) != null ? [1] : []
        content {
          partition_date_source = target_object_key_format.value.partition_date_source
        }
      }
      dynamic "simple_prefix" {
        for_each = try(target_object_key_format.value.partition_date_source, null) == null ? [1] : []
        content {}
      }
    }
  }
}
