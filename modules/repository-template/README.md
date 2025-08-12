# Amazon ECR Repository Template Terraform module

Terraform module which creates Amazon ECR repository template resources.

## Usage

See [`examples`](https://github.com/terraform-aws-modules/terraform-aws-ecr/tree/master/examples) directory for working examples to reference:

### Pull Through Cache Rule

#### Public ECR

```hcl
module "ecr-repository-template" {
  source = "terraform-aws-modules/ecr/aws//modules/repository-template"

  # Template
  description              = "Pull through cache repository template for Karpenter public ECR artifacts"
  prefix                   = "ecr-public"
  create_repository_policy = true

  # Pull through cache rule
  upstream_registry_url = "public.ecr.aws"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
```

#### Private Registry

```hcl
module "ecr-repository-template" {
  source = "terraform-aws-modules/ecr/aws//modules/repository-template"

  # Template
  description = "Pull through cache repository template for NGINX Dockerhub artifacts"
  prefix      = "docker-hub"

  # Pull through cache rule
  upstream_registry_url = "registry-1.docker.io"
  credential_arn = aws_secretsmanager_secret.ecr_pull_through_cache.arn

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
```

### Replication

```hcl
module "ecr" {
  source = "terraform-aws-modules/ecr/aws//modules/repository-template"

  # Template
  description              = "Replication repository template for production ECR artifacts"
  prefix                   = "prod"
  create_repository_policy = true
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

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
```

## Examples

Examples codified under the [`examples`](https://github.com/terraform-aws-modules/terraform-aws-ecr/tree/master/examples) are intended to give users references for how to use the module(s) as well as testing/validating changes to the source code of the module. If contributing to the project, please be sure to make any appropriate updates to the relevant examples to allow maintainers to test your changes and to keep the examples up to date for users. Thank you!

- [Complete](https://github.com/terraform-aws-modules/terraform-aws-ecr/tree/master/examples/complete)
- [Repository Template](https://github.com/terraform-aws-modules/terraform-aws-ecr/tree/master/examples/repository-template)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.8 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.8 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecr_pull_through_cache_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_pull_through_cache_rule) | resource |
| [aws_ecr_repository_creation_template.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_creation_template) | resource |
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.repository](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_applied_for"></a> [applied\_for](#input\_applied\_for) | Which features this template applies to. Must contain one or more of `PULL_THROUGH_CACHE` or `REPLICATION`. Defaults to `PULL_THROUGH_CACHE` | `list(string)` | <pre>[<br/>  "PULL_THROUGH_CACHE"<br/>]</pre> | no |
| <a name="input_create"></a> [create](#input\_create) | Determines whether resources will be created (affects all resources) | `bool` | `true` | no |
| <a name="input_create_iam_role"></a> [create\_iam\_role](#input\_create\_iam\_role) | Determines whether the ECR service IAM role should be created | `bool` | `true` | no |
| <a name="input_create_pull_through_cache_rule"></a> [create\_pull\_through\_cache\_rule](#input\_create\_pull\_through\_cache\_rule) | Determines whether a pull through cache rule will be created | `bool` | `false` | no |
| <a name="input_create_repository_policy"></a> [create\_repository\_policy](#input\_create\_repository\_policy) | Determines whether a repository policy will be created | `bool` | `true` | no |
| <a name="input_credential_arn"></a> [credential\_arn](#input\_credential\_arn) | ARN of the Secret which will be used to authenticate against the registry to use for the pull through cache rule | `string` | `null` | no |
| <a name="input_custom_role_arn"></a> [custom\_role\_arn](#input\_custom\_role\_arn) | A custom IAM role to use for repository creation. Required if using repository tags or KMS encryption | `string` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | The description for this template | `string` | `null` | no |
| <a name="input_encryption_type"></a> [encryption\_type](#input\_encryption\_type) | The type of encryption to use for any created repositories. Must be one of: `AES256` or `KMS`. Defaults to `AES256` | `string` | `"AES256"` | no |
| <a name="input_iam_role_description"></a> [iam\_role\_description](#input\_iam\_role\_description) | Description of the role | `string` | `null` | no |
| <a name="input_iam_role_name"></a> [iam\_role\_name](#input\_iam\_role\_name) | Name to use on IAM role created | `string` | `null` | no |
| <a name="input_iam_role_path"></a> [iam\_role\_path](#input\_iam\_role\_path) | IAM role path | `string` | `null` | no |
| <a name="input_iam_role_permissions_boundary"></a> [iam\_role\_permissions\_boundary](#input\_iam\_role\_permissions\_boundary) | ARN of the policy that is used to set the permissions boundary for the IAM role | `string` | `null` | no |
| <a name="input_iam_role_tags"></a> [iam\_role\_tags](#input\_iam\_role\_tags) | A map of additional tags to add to the IAM role created | `map(string)` | `{}` | no |
| <a name="input_iam_role_use_name_prefix"></a> [iam\_role\_use\_name\_prefix](#input\_iam\_role\_use\_name\_prefix) | Determines whether the IAM role name (`iam_role_name`) is used as a prefix | `bool` | `true` | no |
| <a name="input_image_tag_mutability"></a> [image\_tag\_mutability](#input\_image\_tag\_mutability) | The tag mutability setting for any created repositories. Must be one of: `MUTABLE` or `IMMUTABLE`. Defaults to `IMMUTABLE` | `string` | `"IMMUTABLE"` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN of the KMS key used to encrypt the repositories created | `string` | `null` | no |
| <a name="input_lifecycle_policy"></a> [lifecycle\_policy](#input\_lifecycle\_policy) | The lifecycle policy document to apply to any created repositories | `string` | `null` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | (Required) The repository name prefix to match against. Use `ROOT` to match any prefix that doesn't explicitly match another template | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | Region where this resource will be managed. Defaults to the Region set in the provider configuration. | `string` | `null` | no |
| <a name="input_repository_lambda_read_access_arns"></a> [repository\_lambda\_read\_access\_arns](#input\_repository\_lambda\_read\_access\_arns) | The ARNs of the Lambda service roles that have read access to the repository | `list(string)` | `[]` | no |
| <a name="input_repository_policy"></a> [repository\_policy](#input\_repository\_policy) | The JSON policy to apply to the repository. If not specified, uses the default policy | `string` | `null` | no |
| <a name="input_repository_policy_statements"></a> [repository\_policy\_statements](#input\_repository\_policy\_statements) | A map of IAM policy [statements](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document#statement) for custom permission usage | <pre>map(object({<br/>    sid           = optional(string)<br/>    actions       = optional(list(string))<br/>    not_actions   = optional(list(string))<br/>    effect        = optional(string)<br/>    resources     = optional(list(string))<br/>    not_resources = optional(list(string))<br/>    principals = optional(list(object({<br/>      type        = string<br/>      identifiers = list(string)<br/>    })))<br/>    not_principals = optional(list(object({<br/>      type        = string<br/>      identifiers = list(string)<br/>    })))<br/>    conditions = optional(list(object({<br/>      test     = string<br/>      values   = list(string)<br/>      variable = string<br/>    })))<br/>  }))</pre> | `null` | no |
| <a name="input_repository_read_access_arns"></a> [repository\_read\_access\_arns](#input\_repository\_read\_access\_arns) | The ARNs of the IAM users/roles that have read access to the repository | `list(string)` | `[]` | no |
| <a name="input_repository_read_write_access_arns"></a> [repository\_read\_write\_access\_arns](#input\_repository\_read\_write\_access\_arns) | The ARNs of the IAM users/roles that have read/write access to the repository | `list(string)` | `[]` | no |
| <a name="input_resource_tags"></a> [resource\_tags](#input\_resource\_tags) | A map of tags to assign to any created repositories | `map(string)` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_upstream_registry_url"></a> [upstream\_registry\_url](#input\_upstream\_registry\_url) | The registry URL of the upstream public registry to use as the source for the pull through cache rule | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | IAM role ARN |
| <a name="output_iam_role_name"></a> [iam\_role\_name](#output\_iam\_role\_name) | IAM role name |
| <a name="output_iam_role_unique_id"></a> [iam\_role\_unique\_id](#output\_iam\_role\_unique\_id) | Stable and unique string identifying the IAM role |
<!-- END_TF_DOCS -->

## License

Apache-2.0 Licensed. See [LICENSE](https://github.com/terraform-aws-modules/terraform-aws-ecr/blob/master/LICENSE).
