provider "aws" {
  region = local.region
}

locals {
  region = "us-east-1"
  name   = "ecr-ex-${replace(basename(path.cwd), "_", "-")}"

  account_id = data.aws_caller_identity.current.account_id

  tags = {
    Name       = local.name
    Example    = local.name
    Repository = "https://github.com/terraform-aws-modules/terraform-aws-ecr"
  }
}

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

  repository_image_tag_mutability = "IMMUTABLE_WITH_EXCLUSION"

  repository_image_tag_mutability_exclusion_filter = [
    {
      filter      = "latest*"
      filter_type = "WILDCARD"
    },
    {
      filter      = "dev-*"
      filter_type = "WILDCARD"
    },
    {
      filter      = "qa-*"
      filter_type = "WILDCARD"
    }
  ]

  tags = local.tags
}

#module "public_ecr" {
#  source = "../.."
#
#  repository_name = local.name
#  repository_type = "public"
#
#  repository_read_write_access_arns = [data.aws_caller_identity.current.arn]
#
#  public_repository_catalog_data = {
#    description       = "Docker container for some things"
#    about_text        = file("${path.module}/files/ABOUT.md")
#    usage_text        = file("${path.module}/files/USAGE.md")
#    operating_systems = ["Linux"]
#    architectures     = ["x86"]
#    logo_image_blob   = filebase64("${path.module}/files/clowd.png")
#  }
#
#  tags = local.tags
#}

################################################################################
# ECR Registry
################################################################################

data "aws_iam_policy_document" "registry" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.account_id}:root"]
    }

    actions   = ["ecr:ReplicateImage"]
    resources = [module.ecr.repository_arn]
  }

  statement {
    sid = "dockerhub"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.account_id}:root"]
    }
    actions = [
      "ecr:CreateRepository",
      "ecr:BatchImportUpstreamImage"
    ]
    resources = ["arn:aws:ecr-public::${local.account_id}:repository/dockerhub/*"]
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
      credential_arn        = module.secrets_manager_dockerhub_credentials.secret_arn
    }
    priv = {
      ecr_repository_prefix      = local.name
      upstream_registry_url      = "${data.aws_caller_identity.current.account_id}.dkr.ecr.us-west-2.amazonaws.com"
      upstream_repository_prefix = "myapp"
    }
  }

  # Registry Scanning Configuration
  manage_registry_scanning_configuration = true
  registry_scan_type                     = "ENHANCED"
  registry_scan_rules = [
    {
      scan_frequency = "SCAN_ON_PUSH"
      filter = [
        {
          filter      = "example1"
          filter_type = "WILDCARD"
        },
        { filter      = "example2"
          filter_type = "WILDCARD"
        }
      ]
      }, {
      scan_frequency = "CONTINUOUS_SCAN"
      filter = [
        {
          filter      = "example"
          filter_type = "WILDCARD"
        }
      ]
    }
  ]

  # Registry Replication Configuration
  create_registry_replication_configuration = true
  registry_replication_rules = [{
    destinations = [{
      region      = "us-west-2"
      registry_id = local.account_id
      }, {
      region      = "eu-west-1"
      registry_id = local.account_id
    }]

    repository_filters = [{
      filter      = "prod-microservice"
      filter_type = "PREFIX_MATCH"
    }]
  }]

  tags = local.tags
}

module "secrets_manager_dockerhub_credentials" {
  source  = "terraform-aws-modules/secrets-manager/aws"
  version = "~> 1.0"

  # Secret names must contain 1-512 Unicode characters and be prefixed with ecr-pullthroughcache/
  name_prefix = "ecr-pullthroughcache/dockerhub-credentials"
  description = "Dockerhub credentials"

  # For example only
  recovery_window_in_days = 0
  secret_string = jsonencode({
    username    = "example"
    accessToken = "YouShouldNotStoreThisInPlainText"
  })

  # Policy
  create_policy       = true
  block_public_policy = true
  policy_statements = {
    read = {
      sid = "AllowAccountRead"
      principals = [{
        type        = "AWS"
        identifiers = ["arn:aws:iam::${local.account_id}:root"]
      }]
      actions   = ["secretsmanager:GetSecretValue"]
      resources = ["*"]
    }
  }

  tags = local.tags
}
