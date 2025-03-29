locals {
  create_private_repository = var.create && var.create_repository && var.repository_type == "private"
  create_public_repository  = var.create && var.create_repository && var.repository_type == "public"
}

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

# Policy used by both private and public repositories
data "aws_iam_policy_document" "repository" {
  count = var.create && var.create_repository && var.create_repository_policy ? 1 : 0

  dynamic "statement" {
    for_each = var.repository_type == "public" ? [1] : []

    content {
      sid = "PublicReadOnly"

      principals {
        type = "AWS"
        identifiers = coalescelist(
          var.repository_read_access_arns,
          ["*"],
        )
      }

      actions = [
        "ecr-public:BatchGetImage",
        "ecr-public:GetDownloadUrlForLayer",
      ]
    }
  }

  dynamic "statement" {
    for_each = var.repository_type == "private" ? [1] : []

    content {
      sid = "PrivateReadOnly"

      principals {
        type = "AWS"
        identifiers = coalescelist(
          concat(var.repository_read_access_arns, var.repository_read_write_access_arns),
          ["arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"],
        )
      }

      actions = [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:DescribeImageScanFindings",
        "ecr:DescribeImages",
        "ecr:DescribeRepositories",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetLifecyclePolicy",
        "ecr:GetLifecyclePolicyPreview",
        "ecr:GetRepositoryPolicy",
        "ecr:ListImages",
        "ecr:ListTagsForResource",
      ]
    }
  }

  dynamic "statement" {
    for_each = var.repository_type == "private" && length(var.repository_lambda_read_access_arns) > 0 ? [1] : []

    content {
      sid = "PrivateLambdaReadOnly"

      principals {
        type        = "Service"
        identifiers = ["lambda.amazonaws.com"]
      }

      actions = [
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer",
      ]

      condition {
        test     = "StringLike"
        variable = "aws:sourceArn"

        values = var.repository_lambda_read_access_arns
      }
    }
  }

  dynamic "statement" {
    for_each = length(var.repository_read_write_access_arns) > 0 && var.repository_type == "private" ? [var.repository_read_write_access_arns] : []

    content {
      sid = "ReadWrite"

      principals {
        type        = "AWS"
        identifiers = statement.value
      }

      actions = [
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload",
      ]
    }
  }

  dynamic "statement" {
    for_each = length(var.repository_read_write_access_arns) > 0 && var.repository_type == "public" ? [var.repository_read_write_access_arns] : []

    content {
      sid = "ReadWrite"

      principals {
        type        = "AWS"
        identifiers = statement.value
      }

      actions = [
        "ecr-public:BatchCheckLayerAvailability",
        "ecr-public:CompleteLayerUpload",
        "ecr-public:InitiateLayerUpload",
        "ecr-public:PutImage",
        "ecr-public:UploadLayerPart",
      ]
    }
  }

  dynamic "statement" {
    for_each = var.repository_policy_statements

    content {
      sid           = try(statement.value.sid, null)
      actions       = try(statement.value.actions, null)
      not_actions   = try(statement.value.not_actions, null)
      effect        = try(statement.value.effect, null)
      resources     = try(statement.value.resources, null)
      not_resources = try(statement.value.not_resources, null)

      dynamic "principals" {
        for_each = try(statement.value.principals, [])

        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "not_principals" {
        for_each = try(statement.value.not_principals, [])

        content {
          type        = not_principals.value.type
          identifiers = not_principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = try(statement.value.conditions, [])

        content {
          test     = condition.value.test
          values   = condition.value.values
          variable = condition.value.variable
        }
      }
    }
  }
}

################################################################################
# Repository
################################################################################

resource "aws_ecr_repository" "this" {
  count = local.create_private_repository ? 1 : 0

  name                 = var.repository_name
  image_tag_mutability = var.repository_image_tag_mutability

  encryption_configuration {
    encryption_type = var.repository_encryption_type
    kms_key         = var.repository_kms_key
  }

  force_delete = var.repository_force_delete

  image_scanning_configuration {
    scan_on_push = var.repository_image_scan_on_push
  }

  tags = var.tags
}

################################################################################
# Repository Policy
################################################################################

resource "aws_ecr_repository_policy" "this" {
  count = local.create_private_repository && var.attach_repository_policy ? 1 : 0

  repository = aws_ecr_repository.this[0].name
  policy     = var.create_repository_policy ? data.aws_iam_policy_document.repository[0].json : var.repository_policy
}

################################################################################
# Lifecycle Policy
################################################################################

resource "aws_ecr_lifecycle_policy" "this" {
  count = local.create_private_repository && var.create_lifecycle_policy ? 1 : 0

  repository = aws_ecr_repository.this[0].name
  policy     = var.repository_lifecycle_policy
}

################################################################################
# Public Repository
################################################################################

resource "aws_ecrpublic_repository" "this" {
  count = local.create_public_repository ? 1 : 0

  repository_name = var.repository_name

  dynamic "catalog_data" {
    for_each = length(var.public_repository_catalog_data) > 0 ? [var.public_repository_catalog_data] : []

    content {
      about_text        = try(catalog_data.value.about_text, null)
      architectures     = try(catalog_data.value.architectures, null)
      description       = try(catalog_data.value.description, null)
      logo_image_blob   = try(catalog_data.value.logo_image_blob, null)
      operating_systems = try(catalog_data.value.operating_systems, null)
      usage_text        = try(catalog_data.value.usage_text, null)
    }
  }

  tags = var.tags
}

################################################################################
# Public Repository Policy
################################################################################

resource "aws_ecrpublic_repository_policy" "example" {
  count = local.create_public_repository ? 1 : 0

  repository_name = aws_ecrpublic_repository.this[0].repository_name
  policy          = var.create_repository_policy ? data.aws_iam_policy_document.repository[0].json : var.repository_policy
}

################################################################################
# Registry Policy
################################################################################

resource "aws_ecr_registry_policy" "this" {
  count = var.create && var.create_registry_policy ? 1 : 0

  policy = var.registry_policy
}

################################################################################
# Registry Pull Through Cache Rule
################################################################################

resource "aws_ecr_pull_through_cache_rule" "this" {
  for_each = { for k, v in var.registry_pull_through_cache_rules : k => v if var.create }

  ecr_repository_prefix      = each.value.ecr_repository_prefix
  upstream_registry_url      = each.value.upstream_registry_url
  credential_arn             = try(each.value.credential_arn, null)
  custom_role_arn            = try(each.value.custom_role_arn, null)
  upstream_repository_prefix = try(each.value.upstream_repository_prefix, null)
}

################################################################################
# Registry Scanning Configuration
################################################################################

resource "aws_ecr_registry_scanning_configuration" "this" {
  count = var.create && var.manage_registry_scanning_configuration ? 1 : 0

  scan_type = var.registry_scan_type

  dynamic "rule" {
    for_each = var.registry_scan_rules

    content {
      scan_frequency = rule.value.scan_frequency

      dynamic "repository_filter" {
        for_each = rule.value.filter

        content {
          filter      = repository_filter.value.filter
          filter_type = try(repository_filter.value.filter_type, "WILDCARD")
        }
      }
    }
  }
}

################################################################################
# Registry Replication Configuration
################################################################################

resource "aws_ecr_replication_configuration" "this" {
  count = var.create && var.create_registry_replication_configuration ? 1 : 0

  replication_configuration {

    dynamic "rule" {
      for_each = var.registry_replication_rules

      content {
        dynamic "destination" {
          for_each = rule.value.destinations

          content {
            region      = destination.value.region
            registry_id = destination.value.registry_id
          }
        }

        dynamic "repository_filter" {
          for_each = try(rule.value.repository_filters, [])

          content {
            filter      = repository_filter.value.filter
            filter_type = repository_filter.value.filter_type
          }
        }
      }
    }
  }
}
