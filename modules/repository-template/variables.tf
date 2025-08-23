variable "create" {
  description = "Determines whether resources will be created (affects all resources)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

################################################################################
# Repository Template
################################################################################

variable "applied_for" {
  description = "Which features this template applies to. Must contain one or more of `PULL_THROUGH_CACHE` or `REPLICATION`. Defaults to `PULL_THROUGH_CACHE`"
  type        = list(string)
  default     = ["PULL_THROUGH_CACHE"]
}

variable "custom_role_arn" {
  description = "A custom IAM role to use for repository creation. Required if using repository tags or KMS encryption"
  type        = string
  default     = null
}

variable "description" {
  description = "The description for this template"
  type        = string
  default     = null
}

variable "encryption_type" {
  description = "The type of encryption to use for any created repositories. Must be one of: `AES256` or `KMS`. Defaults to `AES256`"
  type        = string
  default     = "AES256"
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key used to encrypt the repositories created"
  type        = string
  default     = null
}

variable "image_tag_mutability_exclusion_filter" {
  description = "Configuration block that defines filters to specify which image tags can override the default tag mutability setting. Only applicable when image_tag_mutability is set to IMMUTABLE_WITH_EXCLUSION or MUTABLE_WITH_EXCLUSION."
  type = list(object({
    filter      = string
    filter_type = string
  }))
  default = null
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for any created repositories. Must be one of: `MUTABLE` or `IMMUTABLE`. Defaults to `IMMUTABLE`"
  type        = string
  default     = "IMMUTABLE"
}

variable "lifecycle_policy" {
  description = "The lifecycle policy document to apply to any created repositories"
  type        = string
  default     = null
}

variable "prefix" {
  description = "(Required) The repository name prefix to match against. Use `ROOT` to match any prefix that doesn't explicitly match another template"
  type        = string
  default     = ""
}

variable "repository_policy" {
  description = "The JSON policy to apply to the repository. If not specified, uses the default policy"
  type        = string
  default     = null
}

variable "resource_tags" {
  description = "A map of tags to assign to any created repositories"
  type        = map(string)
  default     = {}
}

################################################################################
# Registry Pull Through Cache Rule
################################################################################

variable "create_pull_through_cache_rule" {
  description = "Determines whether a pull through cache rule will be created"
  type        = bool
  default     = false
}

variable "credential_arn" {
  description = "ARN of the Secret which will be used to authenticate against the registry to use for the pull through cache rule"
  type        = string
  default     = null
}

variable "upstream_registry_url" {
  description = "The registry URL of the upstream public registry to use as the source for the pull through cache rule"
  type        = string
  default     = null
}

################################################################################
# Repository Policy
################################################################################

variable "create_repository_policy" {
  description = "Determines whether a repository policy will be created"
  type        = bool
  default     = true
}

variable "repository_read_access_arns" {
  description = "The ARNs of the IAM users/roles that have read access to the repository"
  type        = list(string)
  default     = []
}

variable "repository_lambda_read_access_arns" {
  description = "The ARNs of the Lambda service roles that have read access to the repository"
  type        = list(string)
  default     = []
}

variable "repository_read_write_access_arns" {
  description = "The ARNs of the IAM users/roles that have read/write access to the repository"
  type        = list(string)
  default     = []
}

variable "repository_policy_statements" {
  description = "A map of IAM policy [statements](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document#statement) for custom permission usage"
  type = map(object({
    sid           = optional(string)
    actions       = optional(list(string))
    not_actions   = optional(list(string))
    effect        = optional(string)
    resources     = optional(list(string))
    not_resources = optional(list(string))
    principals = optional(list(object({
      type        = string
      identifiers = list(string)
    })))
    not_principals = optional(list(object({
      type        = string
      identifiers = list(string)
    })))
    conditions = optional(list(object({
      test     = string
      values   = list(string)
      variable = string
    })))
  }))
  default = null
}

################################################################################
# IAM Role
################################################################################

variable "create_iam_role" {
  description = "Determines whether the ECR service IAM role should be created"
  type        = bool
  default     = true
}

variable "iam_role_name" {
  description = "Name to use on IAM role created"
  type        = string
  default     = null
}

variable "iam_role_use_name_prefix" {
  description = "Determines whether the IAM role name (`iam_role_name`) is used as a prefix"
  type        = bool
  default     = true
}

variable "iam_role_path" {
  description = "IAM role path"
  type        = string
  default     = null
}

variable "iam_role_description" {
  description = "Description of the role"
  type        = string
  default     = null
}

variable "iam_role_permissions_boundary" {
  description = "ARN of the policy that is used to set the permissions boundary for the IAM role"
  type        = string
  default     = null
}

variable "iam_role_tags" {
  description = "A map of additional tags to add to the IAM role created"
  type        = map(string)
  default     = {}
}
