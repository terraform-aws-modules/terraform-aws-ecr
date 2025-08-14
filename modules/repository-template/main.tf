data "aws_caller_identity" "current" {
  count = var.create ? 1 : 0
}

data "aws_partition" "current" {
  count = var.create ? 1 : 0
}

################################################################################
# Repository Template
################################################################################

locals {
  kms_encrypt = var.encryption_type == "KMS"
}

resource "aws_ecr_repository_creation_template" "this" {
  count = var.create ? 1 : 0

  applied_for     = var.applied_for
  custom_role_arn = local.create_iam_role ? aws_iam_role.this[0].arn : var.custom_role_arn
  description     = var.description

  dynamic "encryption_configuration" {
    for_each = var.encryption_type != null ? [1] : []

    content {
      encryption_type = var.encryption_type
      kms_key         = local.kms_encrypt ? var.kms_key_arn : null
    }
  }

  image_tag_mutability = var.image_tag_mutability
  lifecycle_policy     = var.lifecycle_policy
  prefix               = var.prefix
  region               = var.region
  repository_policy    = var.create_repository_policy ? data.aws_iam_policy_document.repository[0].json : var.repository_policy

  resource_tags = var.resource_tags
}

################################################################################
# Repository Policy Document
################################################################################

data "aws_iam_policy_document" "repository" {
  count = var.create && var.create_repository_policy ? 1 : 0

  statement {
    sid = "PrivateReadOnly"

    principals {
      type = "AWS"
      identifiers = coalescelist(
        concat(var.repository_read_access_arns, var.repository_read_write_access_arns),
        ["arn:${data.aws_partition.current[0].partition}:iam::${data.aws_caller_identity.current[0].account_id}:root"],
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

  dynamic "statement" {
    for_each = length(var.repository_lambda_read_access_arns) > 0 ? [1] : []

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
    for_each = length(var.repository_read_write_access_arns) > 0 ? [var.repository_read_write_access_arns] : []

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
    for_each = var.repository_policy_statements != null ? var.repository_policy_statements : {}

    content {
      sid           = try(statement.value.sid, null)
      actions       = try(statement.value.actions, null)
      not_actions   = try(statement.value.not_actions, null)
      effect        = try(statement.value.effect, null)
      resources     = try(statement.value.resources, null)
      not_resources = try(statement.value.not_resources, null)

      dynamic "principals" {
        for_each = statement.value.principals != null ? statement.value.principals : []

        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "not_principals" {
        for_each = statement.value.not_principals != null ? statement.value.not_principals : []

        content {
          type        = not_principals.value.type
          identifiers = not_principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = statement.value.conditions != null ? statement.value.conditions : []

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
# Registry Pull Through Cache Rule
################################################################################

resource "aws_ecr_pull_through_cache_rule" "this" {
  count = var.create && var.create_pull_through_cache_rule ? 1 : 0

  credential_arn        = var.credential_arn
  ecr_repository_prefix = var.prefix
  upstream_registry_url = var.upstream_registry_url
  region                = var.region
}

################################################################################
# IAM Role
################################################################################

locals {
  create_iam_role = var.create && var.create_iam_role && (local.kms_encrypt || length(var.resource_tags) > 0)
  iam_role_name   = try(coalesce(var.iam_role_name, var.prefix), "")

  perm_prefix = var.prefix != "ROOT" ? "${var.prefix}/*" : "*"
}

data "aws_iam_policy_document" "assume" {
  count = local.create_iam_role ? 1 : 0

  statement {
    sid     = "ECRServiceAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecr.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  count = local.create_iam_role ? 1 : 0

  name        = var.iam_role_use_name_prefix ? null : local.iam_role_name
  name_prefix = var.iam_role_use_name_prefix ? "${local.iam_role_name}-" : null
  path        = var.iam_role_path
  description = var.iam_role_description

  assume_role_policy    = data.aws_iam_policy_document.assume[0].json
  permissions_boundary  = var.iam_role_permissions_boundary
  force_detach_policies = true

  tags = merge(var.tags, var.iam_role_tags)
}

data "aws_iam_policy_document" "this" {
  count = local.create_iam_role ? 1 : 0

  statement {
    sid = "TagResource"
    actions = [
      "ecr:CreateRepository",
      "ecr:ReplicateImage",
      "ecr:TagResource"
    ]
    resources = [
      "arn:${data.aws_partition.current[0].partition}:ecr:*:${data.aws_caller_identity.current[0].account_id}:repository/${local.perm_prefix}"
    ]
  }

  dynamic "statement" {
    for_each = local.kms_encrypt ? [1] : []

    content {
      sid = "KMSUsage"
      actions = [
        "kms:CreateGrant",
        "kms:RetireGrant",
        "kms:DescribeKey",
      ]
      resources = [var.kms_key_arn]
    }
  }
}

resource "aws_iam_policy" "this" {
  count = local.create_iam_role ? 1 : 0

  name        = var.iam_role_use_name_prefix ? null : local.iam_role_name
  name_prefix = var.iam_role_use_name_prefix ? "${local.iam_role_name}-" : null
  description = coalesce(var.iam_role_description, "ECR service policy that allows Amazon ECR to make calls to tag resources and use KMS encryption key(s) on your behalf")
  policy      = data.aws_iam_policy_document.this[0].json

  tags = merge(var.tags, var.iam_role_tags)
}

resource "aws_iam_role_policy_attachment" "this" {
  count = local.create_iam_role ? 1 : 0

  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.this[0].arn
}
