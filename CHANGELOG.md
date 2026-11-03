# Changelog

All notable changes to this module are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
This file must be updated as part of every change to this module.

## [2.0.0] - 2026-11-02

Also releases the changes of 1.1.0 below, which were never tagged.

### Changed

- **Breaking:** the `object` output lists the attributes of the bucket that the provider has not deprecated (`id`, `arn`, `bucket`,
  `bucket_domain_name`, `bucket_regional_domain_name`, `bucket_region`, `hosted_zone_id`, `region`, `object_lock_enabled`,
  `force_destroy`, `tags_all`) instead of returning the whole `aws_s3_bucket` resource. Validating a composition that uses the module no
  longer warns about `acceleration_status`, `acl`, `policy`, `request_payer`, `website_domain` and `website_endpoint`. A consumer that reads
  one of those six from `object` reads the matching `aws_s3_bucket_*` configuration instead, through its own resource. The outputs
  `id`, `arn`, `bucket` and `bucket_domain_name` are unchanged.

## [1.1.0] - 2026-09-04

### Added

- Full feature support for aws provider `~> 6.0` (tested against `6.63.0`),
  covering every `aws_s3_bucket_*` resource:
  - `aws_s3_bucket_ownership_controls`, `aws_s3_bucket_acl` (canned ACL or
    `access_control_policy`), `aws_s3_bucket_policy`,
    `aws_s3_bucket_request_payment_configuration`,
    `aws_s3_bucket_accelerate_configuration`, `aws_s3_bucket_abac`
  - `aws_s3_bucket_lifecycle_configuration` with full nested rule/filter/
    transition support
  - `aws_s3_bucket_website_configuration`, `aws_s3_bucket_cors_configuration`,
    `aws_s3_bucket_logging`
  - `aws_s3_bucket_notification` (lambda/queue/topic/eventbridge)
  - `aws_s3_bucket_replication_configuration` with full nested rule/
    destination/filter/source_selection_criteria support
  - `aws_s3_bucket_analytics_configuration`,
    `aws_s3_bucket_intelligent_tiering_configuration`,
    `aws_s3_bucket_inventory`, `aws_s3_bucket_metric` (all map-keyed for
    multiple named configurations)
  - `aws_s3_bucket_metadata_configuration` (S3 Metadata journal/inventory
    table configuration)
  - `aws_s3_bucket_object_lock_configuration`
  - New `bucket` object attributes: `object_lock_enabled`, `mfa`,
    `mfa_delete`, `blocked_encryption_types`, `skip_destroy`
- Expanded `tests/s3_bucket.tftest.hcl` to 16 test runs covering every
  feature.
- Updated `README.md` and `ESLZ/s3_bucket.tfvars` to document/demonstrate
  the full feature set.

### Changed

- Bumped required `aws` provider version to `~> 6.0` (from `~> 5.0`).

## [1.0.0] - 2026-09-04

### Added

- Initial release: `aws_s3_bucket` with versioning, server-side encryption
  (AES256/aws:kms), and public access block, following the
  terraform-azurerm-caf-storage_accountV2 module conventions (single
  `bucket` object variable, `locals.tf`/`name.tf` split, ESLZ `for_each`
  wrapper).
