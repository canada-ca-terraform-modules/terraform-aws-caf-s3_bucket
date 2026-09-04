# terraform-aws-caf-s3_bucket

CAF-compliant Terraform module for creating an AWS S3 bucket, with versioning, server-side encryption and public access block support.

## Usage

### ESLZ module block (`ESLZ/s3_bucket.tf`)

```hcl
module "s3_bucket" {
  source   = "github.com/canada-ca-terraform-modules/terraform-aws-caf-s3_bucket.git?ref=v1.0.0"
  for_each = var.s3buckets

  env               = var.env
  userDefinedString = each.key
  bucket            = each.value
  tags              = var.tags
}
```

See [`ESLZ/s3_bucket.tfvars`](ESLZ/s3_bucket.tfvars) for the full set of `bucket` object parameters.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_bucket"></a> [bucket](#input\_bucket) | (Required) Object describing the S3 bucket (see TFVars Parameters below) | `any` | `{}` | no |
| <a name="input_env"></a> [env](#input\_env) | (Required) env value used in name generation | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to all resources (merged with bucket.tags) | `map(string)` | `{}` | no |
| <a name="input_userDefinedString"></a> [userDefinedString](#input\_userDefinedString) | (Required) UserDefinedString part of the name of the bucket | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_arn"></a> [arn](#output\_arn) | Returns the ARN of the S3 bucket |
| <a name="output_bucket"></a> [bucket](#output\_bucket) | Returns the name of the S3 bucket |
| <a name="output_bucket_domain_name"></a> [bucket\_domain\_name](#output\_bucket\_domain\_name) | Returns the domain name of the S3 bucket |
| <a name="output_id"></a> [id](#output\_id) | Returns the ID of the S3 bucket |
| <a name="output_object"></a> [object](#output\_object) | Returns the full S3 bucket object |
<!-- END_TF_DOCS -->

## TFVars Parameters

For full provider documentation see: <https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket>

All parameters are set inside the `bucket` object key in your tfvars.

### Optional

| Name | Possible values | Notes |
|------|----------------|-------|
| `versioning_enabled` | `true`, `false` | Default: `true` |
| `sse_algorithm` | `AES256`, `aws:kms` | Default: `AES256` |
| `kms_key_id` | KMS key ARN | Required when `sse_algorithm = "aws:kms"` |
| `bucket_key_enabled` | `true`, `false` | Default: `true`. Only applies to SSE-KMS |
| `force_destroy` | `true`, `false` | Default: `false`. Deletes all objects on bucket destroy |
| `block_public_acls` | `true`, `false` | Default: `true` |
| `block_public_policy` | `true`, `false` | Default: `true` |
| `ignore_public_acls` | `true`, `false` | Default: `true` |
| `restrict_public_buckets` | `true`, `false` | Default: `true` |
| `tags` | `map(string)` | Merged with ESLZ-level `tags` |
