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

variable "repository_type" {
  description = "The type of repository to create. Either `public` or `private`"
  type        = string
  default     = "private"
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

################################################################################
# Repository
################################################################################

variable "create_repository" {
  description = "Determines whether a repository will be created"
  type        = bool
  default     = true
}

variable "repository_name" {
  description = "The name of the repository"
  type        = string
  default     = ""
}

variable "repository_image_tag_mutability" {
  description = "The tag mutability setting for the repository. Must be one of: `MUTABLE`, `MUTABLE_WITH_EXCLUSION`, `IMMUTABLE`, or `IMMUTABLE_WITH_EXCLUSION`. Defaults to `IMMUTABLE`"
  type        = string
  default     = "IMMUTABLE"
}

variable "repository_encryption_type" {
  description = "The encryption type for the repository. Must be one of: `KMS` or `AES256`. Defaults to `AES256`"
  type        = string
  default     = null
}

variable "repository_kms_key" {
  description = "The ARN of the KMS key to use when encryption_type is `KMS`. If not specified, uses the default AWS managed key for ECR"
  type        = string
  default     = null
}

variable "repository_image_scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository (`true`) or not scanned (`false`)"
  type        = bool
  default     = true
}

variable "repository_policy" {
  description = "The JSON policy to apply to the repository. If not specified, uses the default policy"
  type        = string
  default     = null
}

variable "repository_force_delete" {
  description = "If `true`, will delete the repository even if it contains images. Defaults to `false`"
  type        = bool
  default     = null
}

variable "repository_image_tag_mutability_exclusion_filter" {
  description = "Configuration block that defines filters to specify which image tags can override the default tag mutability setting. Only applicable when image_tag_mutability is set to IMMUTABLE_WITH_EXCLUSION or MUTABLE_WITH_EXCLUSION."
  type = list(object({
    filter      = string
    filter_type = string
  }))
  default = null
}

################################################################################
# Repository Policy
################################################################################

variable "attach_repository_policy" {
  description = "Determines whether a repository policy will be attached to the repository"
  type        = bool
  default     = true
}

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
# Lifecycle Policy
################################################################################

variable "create_lifecycle_policy" {
  description = "Determines whether a lifecycle policy will be created"
  type        = bool
  default     = true
}

variable "repository_lifecycle_policy" {
  description = "The policy document. This is a JSON formatted string. See more details about [Policy Parameters](http://docs.aws.amazon.com/AmazonECR/latest/userguide/LifecyclePolicies.html#lifecycle_policy_parameters) in the official AWS docs"
  type        = string
  default     = ""
}

################################################################################
# Public Repository
################################################################################

variable "public_repository_catalog_data" {
  description = "Catalog data configuration for the repository"
  type = object({
    about_text        = optional(string)
    architectures     = optional(list(string))
    description       = optional(string)
    logo_image_blob   = optional(string)
    operating_systems = optional(list(string))
    usage_text        = optional(string)
  })
  default = null
}

################################################################################
# Registry Policy
################################################################################

variable "create_registry_policy" {
  description = "Determines whether a registry policy will be created"
  type        = bool
  default     = false
}

variable "registry_policy" {
  description = "The policy document. This is a JSON formatted string"
  type        = string
  default     = null
}

################################################################################
# Registry Pull Through Cache Rule
################################################################################

variable "registry_pull_through_cache_rules" {
  description = "List of pull through cache rules to create"
  type = map(object({
    ecr_repository_prefix      = string
    upstream_registry_url      = string
    credential_arn             = optional(string)
    custom_role_arn            = optional(string)
    upstream_repository_prefix = optional(string)
    region                     = optional(string)
  }))
  default = {}
}

################################################################################
# Registry Scanning Configuration
################################################################################

variable "manage_registry_scanning_configuration" {
  description = "Determines whether the registry scanning configuration will be managed"
  type        = bool
  default     = false
}

variable "registry_scan_type" {
  description = "the scanning type to set for the registry. Can be either `ENHANCED` or `BASIC`"
  type        = string
  default     = "ENHANCED"
}

variable "registry_scan_rules" {
  description = "One or multiple blocks specifying scanning rules to determine which repository filters are used and at what frequency scanning will occur"
  type = list(object({
    scan_frequency = string
    filter = list(object({
      filter      = string
      filter_type = optional(string)
    }))
  }))
  default = null
}

################################################################################
# Registry Replication Configuration
################################################################################

variable "create_registry_replication_configuration" {
  description = "Determines whether a registry replication configuration will be created"
  type        = bool
  default     = false
}

variable "registry_replication_rules" {
  description = "The replication rules for a replication configuration. A maximum of 10 are allowed"
  type = list(object({
    destinations = list(object({
      region      = string
      registry_id = string
    }))
    repository_filters = optional(list(object({
      filter      = string
      filter_type = string
    })))
  }))
  default = null
}
