# Changelog

All notable changes to this module are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
This file must be updated as part of every change to this module.

## [1.0.0] - 2026-09-04

### Added

- Initial release: `aws_s3_bucket` with versioning, server-side encryption
  (AES256/aws:kms), and public access block, following the
  terraform-azurerm-caf-storage_accountV2 module conventions (single
  `bucket` object variable, `locals.tf`/`name.tf` split, ESLZ `for_each`
  wrapper).
