# Deploys an AWS S3 Bucket

Creates an AWS S3 bucket with versioning, default server-side encryption, and
public access blocked by default.

## Usage

```hcl
module "s3_bucket" {
  source = "github.com/canada-ca-terraform-modules/terraform-aws-caf-s3_bucket?ref=v1.0.0"

  env               = var.env
  userDefinedString = "my-app-data"
  tags              = { environment = "dev" }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.9 |
| aws | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| tags | Tags to be applied to the S3 bucket to be created | `map(string)` | n/a | yes |
| env | (Required) env value | `string` | n/a | yes |
| userDefinedString | UserDefinedString part of the name of the resource | `string` | n/a | yes |
| force_destroy | A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. | `bool` | `false` | no |
| versioning_enabled | Enable versioning on the bucket. | `bool` | `true` | no |
| sse_algorithm | Server-side encryption algorithm. Valid values are AES256 and aws:kms. | `string` | `"AES256"` | no |
| kms_key_id | AWS KMS master key ID used for SSE-KMS encryption. Required when sse_algorithm is aws:kms. | `string` | `null` | no |
| bucket_key_enabled | Whether to use Amazon S3 Bucket Keys for SSE-KMS. | `bool` | `true` | no |
| block_public_acls | Whether Amazon S3 should block public ACLs for this bucket. | `bool` | `true` | no |
| block_public_policy | Whether Amazon S3 should block public bucket policies for this bucket. | `bool` | `true` | no |
| ignore_public_acls | Whether Amazon S3 should ignore public ACLs for this bucket. | `bool` | `true` | no |
| restrict_public_buckets | Whether Amazon S3 should restrict public bucket policies for this bucket. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| object | returns the full S3 Bucket Object |
| id | returns the ID of the S3 bucket |
| arn | returns the ARN of the S3 bucket |
| bucket | returns the name of the S3 bucket |
| bucket_domain_name | returns the domain name of the S3 bucket |
