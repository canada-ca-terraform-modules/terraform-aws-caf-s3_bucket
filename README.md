# terraform-aws-caf-s3_bucket

CAF-compliant Terraform module for creating an AWS S3 bucket. Supports the full `aws_s3_bucket_*` resource surface available in aws provider `~> 6.0` (tested against `6.63.0`): versioning, server-side encryption, public access block, ownership controls, ACLs, bucket policy, request payment, transfer acceleration, ABAC, object lock, lifecycle rules, static website hosting, CORS, access logging, event notifications, replication, analytics/intelligent-tiering/inventory/metrics configurations, and S3 Metadata tables.

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
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_abac.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_abac) | resource |
| [aws_s3_bucket_accelerate_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_accelerate_configuration) | resource |
| [aws_s3_bucket_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_analytics_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_analytics_configuration) | resource |
| [aws_s3_bucket_cors_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_cors_configuration) | resource |
| [aws_s3_bucket_intelligent_tiering_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_intelligent_tiering_configuration) | resource |
| [aws_s3_bucket_inventory.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_inventory) | resource |
| [aws_s3_bucket_lifecycle_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_logging.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_metadata_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_metadata_configuration) | resource |
| [aws_s3_bucket_metric.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_metric) | resource |
| [aws_s3_bucket_notification.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_s3_bucket_object_lock_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object_lock_configuration) | resource |
| [aws_s3_bucket_ownership_controls.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_replication_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_replication_configuration) | resource |
| [aws_s3_bucket_request_payment_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_request_payment_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_website_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |

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

For full provider documentation see: <https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket> (and the `aws_s3_bucket_*` resources linked in the Resources table above). Object-typed keys below accept the same shape as the corresponding resource's arguments/blocks.

All parameters are set inside the `bucket` object key in your tfvars.

### Core (always applied)

| Name | Possible values | Notes |
|------|----------------|-------|
| `versioning_enabled` | `true`, `false` | Default: `true` |
| `mfa_delete` | `true`, `false` | Requires `mfa` and bucket owner root credentials |
| `mfa` | string | MFA device serial + code, required to change `mfa_delete` |
| `sse_algorithm` | `AES256`, `aws:kms` | Default: `AES256` |
| `kms_key_id` | KMS key ARN | Required when `sse_algorithm = "aws:kms"` |
| `bucket_key_enabled` | `true`, `false` | Default: `true`. Only applies to SSE-KMS |
| `blocked_encryption_types` | list of `AES256`/`aws:kms`/`aws:kms:dsse` | Optional deny-list |
| `force_destroy` | `true`, `false` | Default: `false`. Deletes all objects on bucket destroy |
| `object_lock_enabled` | `true`, `false` | Forces new resource; required before `object_lock_configuration` can be used |
| `block_public_acls` | `true`, `false` | Default: `true` |
| `block_public_policy` | `true`, `false` | Default: `true` |
| `ignore_public_acls` | `true`, `false` | Default: `true` |
| `restrict_public_buckets` | `true`, `false` | Default: `true` |
| `skip_destroy` | `true`, `false` | Leaves the public access block in place on `terraform destroy` |
| `tags` | `map(string)` | Merged with ESLZ-level `tags` |

### Optional feature blocks

Each key below is optional and creates its matching `aws_s3_bucket_*` resource only when set.

| Name | Type | Maps to |
|------|------|---------|
| `ownership_controls` | object `{ object_ownership }` | `aws_s3_bucket_ownership_controls` |
| `acl` | string (canned ACL) | `aws_s3_bucket_acl.acl` |
| `access_control_policy` | object `{ owner, grant[] }` | `aws_s3_bucket_acl.access_control_policy` (mutually exclusive with `acl`) |
| `policy` | string (JSON) | `aws_s3_bucket_policy` |
| `request_payer` | `BucketOwner`, `Requester` | `aws_s3_bucket_request_payment_configuration` |
| `accelerate_status` | `Enabled`, `Suspended` | `aws_s3_bucket_accelerate_configuration` |
| `abac_status` | `Enabled`, `Disabled` | `aws_s3_bucket_abac` |
| `object_lock_configuration` | object `{ default_retention }` | `aws_s3_bucket_object_lock_configuration` (requires `object_lock_enabled = true`) |
| `lifecycle_rule` | list of rule objects | `aws_s3_bucket_lifecycle_configuration` |
| `transition_default_minimum_object_size` | string | `aws_s3_bucket_lifecycle_configuration.transition_default_minimum_object_size` |
| `website` | object `{ index_document, error_document, redirect_all_requests_to, routing_rule[], routing_rules }` | `aws_s3_bucket_website_configuration` |
| `cors_rule` | list of rule objects | `aws_s3_bucket_cors_configuration` |
| `logging` | object `{ target_bucket, target_prefix, target_grant[], target_object_key_format }` | `aws_s3_bucket_logging` |
| `notification` | object `{ lambda_function[], queue[], topic[], eventbridge }` | `aws_s3_bucket_notification` |
| `replication` | object `{ role, rule[] }` | `aws_s3_bucket_replication_configuration` (requires `versioning_enabled = true`) |
| `analytics` | map(name → config) | `aws_s3_bucket_analytics_configuration` |
| `intelligent_tiering` | map(name → config) | `aws_s3_bucket_intelligent_tiering_configuration` |
| `inventory` | map(name → config) | `aws_s3_bucket_inventory` |
| `metric` | map(name → config) | `aws_s3_bucket_metric` |
| `metadata_configuration` | object `{ inventory_table_configuration, journal_table_configuration }` | `aws_s3_bucket_metadata_configuration` |

See [`ESLZ/s3_bucket.tfvars`](ESLZ/s3_bucket.tfvars) for worked examples of each block.
