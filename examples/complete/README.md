# Complete AWS ECR Example

Configuration in this directory creates:

- Private ECR repository
- Public ECR repository
- Registry settings
  - Registry policy
  - Pull through cache rules
  - Scanning configuration
  - Replication configuration

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which will incur monetary charges on your AWS bill. Run `terraform destroy` when you no longer need these resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.37 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.37 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecr"></a> [ecr](#module\_ecr) | ../.. | n/a |
| <a name="module_ecr_disabled"></a> [ecr\_disabled](#module\_ecr\_disabled) | ../.. | n/a |
| <a name="module_ecr_registry"></a> [ecr\_registry](#module\_ecr\_registry) | ../.. | n/a |
| <a name="module_public_ecr"></a> [public\_ecr](#module\_public\_ecr) | ../.. | n/a |
| <a name="module_secrets_manager_dockerhub_credentials"></a> [secrets\_manager\_dockerhub\_credentials](#module\_secrets\_manager\_dockerhub\_credentials) | terraform-aws-modules/secrets-manager/aws | ~> 1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.registry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_public_repository_arn"></a> [public\_repository\_arn](#output\_public\_repository\_arn) | Full ARN of the repository |
| <a name="output_public_repository_name"></a> [public\_repository\_name](#output\_public\_repository\_name) | Name of the repository |
| <a name="output_public_repository_registry_id"></a> [public\_repository\_registry\_id](#output\_public\_repository\_registry\_id) | The registry ID where the repository was created |
| <a name="output_public_repository_url"></a> [public\_repository\_url](#output\_public\_repository\_url) | The URL of the repository (in the form `aws_account_id.dkr.ecr.region.amazonaws.com/repositoryName`) |
| <a name="output_repository_arn"></a> [repository\_arn](#output\_repository\_arn) | Full ARN of the repository |
| <a name="output_repository_name"></a> [repository\_name](#output\_repository\_name) | Name of the repository |
| <a name="output_repository_registry_id"></a> [repository\_registry\_id](#output\_repository\_registry\_id) | The registry ID where the repository was created |
| <a name="output_repository_url"></a> [repository\_url](#output\_repository\_url) | The URL of the repository (in the form `aws_account_id.dkr.ecr.region.amazonaws.com/repositoryName`) |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

Apache-2.0 Licensed. See [LICENSE](https://github.com/terraform-aws-modules/terraform-aws-ecr/blob/master/LICENSE).
