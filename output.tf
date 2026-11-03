# The attributes of the bucket that are not deprecated by the provider; returning aws_s3_bucket.this whole makes every consumer
# warn about acceleration_status, acl, policy, request_payer, website_domain and website_endpoint.
output "object" {
  description = "Returns the attributes of the S3 bucket that the provider has not deprecated"
  value = {
    id                          = aws_s3_bucket.this.id
    arn                         = aws_s3_bucket.this.arn
    bucket                      = aws_s3_bucket.this.bucket
    bucket_domain_name          = aws_s3_bucket.this.bucket_domain_name
    bucket_regional_domain_name = aws_s3_bucket.this.bucket_regional_domain_name
    bucket_region               = aws_s3_bucket.this.bucket_region
    hosted_zone_id              = aws_s3_bucket.this.hosted_zone_id
    region                      = aws_s3_bucket.this.region
    object_lock_enabled         = aws_s3_bucket.this.object_lock_enabled
    force_destroy               = aws_s3_bucket.this.force_destroy
    tags_all                    = aws_s3_bucket.this.tags_all
  }
  sensitive = true
}

output "id" {
  description = "Returns the ID of the S3 bucket"
  value       = aws_s3_bucket.this.id
}

output "arn" {
  description = "Returns the ARN of the S3 bucket"
  value       = aws_s3_bucket.this.arn
}

output "bucket" {
  description = "Returns the name of the S3 bucket"
  value       = aws_s3_bucket.this.bucket
}

output "bucket_domain_name" {
  description = "Returns the domain name of the S3 bucket"
  value       = aws_s3_bucket.this.bucket_domain_name
}
