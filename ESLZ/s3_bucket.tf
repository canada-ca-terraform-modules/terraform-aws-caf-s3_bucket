terraform {
  required_version = ">= 1.9"
}

variable "s3buckets" {
  description = "S3 buckets to deploy"
  type        = any
  default     = {}
}

module "s3_bucket" {
  source   = "github.com/canada-ca-terraform-modules/terraform-aws-caf-s3_bucket.git?ref=v1.0.0"
  for_each = var.s3buckets

  userDefinedString = each.key
  env               = var.env
  bucket            = each.value
  tags              = var.tags
}
