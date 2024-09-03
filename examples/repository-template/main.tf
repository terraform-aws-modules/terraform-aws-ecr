provider "aws" {
  region = local.region
}

locals {
  region = "us-east-1"
  name   = "ecr-ex-${basename(path.cwd)}"

  account_id = data.aws_caller_identity.current.account_id

  tags = {
    Name       = local.name
    Example    = local.name
    Repository = "https://github.com/terraform-aws-modules/terraform-aws-ecr"
  }
}

data "aws_caller_identity" "current" {}

################################################################################
# ECR Repository Template
################################################################################

module "public_ecr_pull_through_cache_repository_template" {
  source = "../../modules/repository-template"

  # Template
  description   = "Pull through cache repository template for Public ECR artifacts"
  prefix        = "public-ecr"
  resource_tags = local.tags
  lifecycle_policy = jsonencode({
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

  # Pull through cache rule
  create_pull_through_cache_rule = true
  upstream_registry_url          = "public.ecr.aws"

  tags = local.tags
}

module "dockerhub_pull_through_cache_repository_template" {
  source = "../../modules/repository-template"

  # Template
  description   = "Pull through cache repository template for Dockerhub artifacts"
  prefix        = "dockerhub"
  resource_tags = local.tags

  # Pull through cache rule
  create_pull_through_cache_rule = true
  upstream_registry_url          = "registry-1.docker.io"
  credential_arn                 = module.secrets_manager_dockerhub_credentials.secret_arn

  tags = local.tags
}

module "disabled" {
  source = "../../modules/repository-template"

  create = false
}

################################################################################
# Supporting Resources
################################################################################

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
