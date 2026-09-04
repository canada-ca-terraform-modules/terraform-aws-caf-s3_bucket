variable "tags" {
  description = "Tags applied to all resources (merged with bucket.tags)"
  type        = map(string)
  default     = {}
}

variable "env" {
  description = "(Required) env value used in name generation"
  type        = string
}

variable "userDefinedString" {
  description = "(Required) UserDefinedString part of the name of the bucket"
  type        = string
}

variable "bucket" {
  description = "(Required) Object describing the S3 bucket (see TFVars Parameters below)"
  type        = any
  default     = {}
}
