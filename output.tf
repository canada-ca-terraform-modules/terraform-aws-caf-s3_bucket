output "object" {
  description = "Returns the full S3 bucket object"
  value       = aws_s3_bucket.this
  sensitive   = true
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
