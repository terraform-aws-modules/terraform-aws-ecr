provider "aws" {
  region = local.region
}

locals {
  region = "us-east-1"
  name   = "ecr-ex-${replace(basename(path.cwd), "_", "-")}"

  tags = {
    Name       = local.name
    Example    = local.name
    Repository = "https://github.com/terraform-aws-modules/terraform-aws-ecr"
  }
}

data "aws_partition" "current" {}
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

################################################################################
# ECR Repository
################################################################################

module "ecr_disabled" {
  source = "../.."

  create = false
}

module "ecr" {
  source = "../.."

  repository_name = local.name

  repository_read_write_access_arns = [data.aws_caller_identity.current.arn]
  create_lifecycle_policy           = true
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  repository_force_delete = true

  tags = local.tags
}

module "public_ecr" {
  source = "../.."

  repository_name = local.name
  repository_type = "public"

  repository_read_write_access_arns = [data.aws_caller_identity.current.arn]
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  public_repository_catalog_data = {
    description       = "Docker container for some things"
    about_text        = file("${path.module}/files/ABOUT.md")
    usage_text        = file("${path.module}/files/USAGE.md")
    operating_systems = ["Linux"]
    architectures     = ["x86"]
    logo_image_blob   = filebase64("${path.module}/files/clowd.png")
  }

  tags = local.tags
}

################################################################################
# ECR Registry
################################################################################

data "aws_iam_policy_document" "registry" {
  statement {
    principals {
      type = "AWS"
      identifiers = [
        "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }

    actions = [
      "ecr:ReplicateImage",
    ]

    resources = [
      module.ecr.repository_arn,
    ]
  }

  statement {
    sid = "ecr-public"
    principals {
      type = "AWS"
      identifiers = [
        format("arn:%s:iam::%s:root", data.aws_partition.current.partition, data.aws_caller_identity.current.account_id)
      ]
    }
    actions = [
      "ecr:CreateRepository",
      "ecr:BatchImportUpstreamImage"
    ]
    resources = [
      format("arn:%s:iam:%s:%s:repository/ecr-public/*", data.aws_partition.current.partition, data.aws_region.current.name, data.aws_caller_identity.current.account_id)
    ]
  }

  statement {
    sid = "dockerhub"
    principals {
      type = "AWS"
      identifiers = [
        format("arn:%s:iam::%s:root", data.aws_partition.current.partition, data.aws_caller_identity.current.account_id)
      ]
    }
    actions = [
      "ecr:CreateRepository",
      "ecr:BatchImportUpstreamImage"
    ]
    resources = [
      format("arn:%s:iam:%s:%s:repository/dockerhub/*", data.aws_partition.current.partition, data.aws_region.current.name, data.aws_caller_identity.current.account_id)
    ]
  }
}

module "ecr_registry" {
  source = "../.."

  create_repository = false

  # Registry Policy
  create_registry_policy = true
  registry_policy        = data.aws_iam_policy_document.registry.json

  # Registry Pull Through Cache Rules
  registry_pull_through_cache_rules = {
    pub = {
      ecr_repository_prefix = "ecr-public"
      upstream_registry_url = "public.ecr.aws"
    }
    dockerhub = {
      ecr_repository_prefix = "dockerhub"
      upstream_registry_url = "registry-1.docker.io"
      credential_arn        = module.dockerhub_credentials.secret_arn
    }
  }

  # Registry Scanning Configuration
  manage_registry_scanning_configuration = true
  registry_scan_type                     = "ENHANCED"
  registry_scan_rules = [
    {
      scan_frequency = "SCAN_ON_PUSH"
      filter         = "*"
      filter_type    = "WILDCARD"
      }, {
      scan_frequency = "CONTINUOUS_SCAN"
      filter         = "example"
      filter_type    = "WILDCARD"
    }
  ]

  # Registry Replication Configuration
  create_registry_replication_configuration = true
  registry_replication_rules = [
    {
      destinations = [
        {
          region      = "us-west-2"
          registry_id = data.aws_caller_identity.current.account_id
          }, {
          region      = "eu-west-1"
          registry_id = data.aws_caller_identity.current.account_id
        }
      ]

      repository_filters = [
        {
          filter      = "prod-microservice"
          filter_type = "PREFIX_MATCH"
        }
      ]
    }
  ]

  tags = local.tags
}

# Make sure to read https://docs.aws.amazon.com/AmazonECR/latest/userguide/pull-through-cache-creating-secret.html
module "dockerhub_credentials" {
  source = "terraform-aws-modules/secrets-manager/aws"

  # Secret names must contain 1-512 Unicode characters and be prefixed with ecr-pullthroughcache/.
  name_prefix             = "ecr-pullthroughcache/dockerhub-credentials"
  description             = "Dockerhub credentials"
  recovery_window_in_days = 30

  secret_string = jsonencode(var.dockerhub_credentials)

  # Policy
  create_policy       = true
  block_public_policy = true
  policy_statements = {
    read = {
      sid = "AllowAccountRead"
      principals = [
        {
          type = "AWS"
          identifiers = [
            format("arn:%s:iam::%s:root", data.aws_partition.current.partition, data.aws_caller_identity.current.account_id)
          ]
        }
      ]
      actions   = ["secretsmanager:GetSecretValue"]
      resources = ["*"]
    }
  }

  tags = local.tags
}
