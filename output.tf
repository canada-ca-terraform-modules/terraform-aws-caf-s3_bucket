output "object" {
  value       = aws_s3_bucket.this
  description = "returns the full S3 Bucket Object"
  sensitive   = true
}

output "id" {
  value       = aws_s3_bucket.this.id
  description = "returns the ID of the S3 bucket"
}

output "arn" {
  value       = aws_s3_bucket.this.arn
  description = "returns the ARN of the S3 bucket"
}

output "bucket" {
  value       = aws_s3_bucket.this.bucket
  description = "returns the name of the S3 bucket"
}

output "bucket_domain_name" {
  value       = aws_s3_bucket.this.bucket_domain_name
  description = "returns the domain name of the S3 bucket"
}
