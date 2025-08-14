# Amazon ECR Repository Template Example

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

You can validate this example by running the commands generated in the `example_docker_pull_commands` output value.

Note that this example may create resources which will incur monetary charges on your AWS bill. Run `terraform destroy` when you no longer need these resources.

If you validate the example by using the pull-through cache, you will need to manually clean up these repositories within ECR since they are not manage by Terraform.

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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_disabled"></a> [disabled](#module\_disabled) | ../../modules/repository-template | n/a |
| <a name="module_dockerhub_pull_through_cache_repository_template"></a> [dockerhub\_pull\_through\_cache\_repository\_template](#module\_dockerhub\_pull\_through\_cache\_repository\_template) | ../../modules/repository-template | n/a |
| <a name="module_public_ecr_pull_through_cache_repository_template"></a> [public\_ecr\_pull\_through\_cache\_repository\_template](#module\_public\_ecr\_pull\_through\_cache\_repository\_template) | ../../modules/repository-template | n/a |
| <a name="module_secrets_manager_dockerhub_credentials"></a> [secrets\_manager\_dockerhub\_credentials](#module\_secrets\_manager\_dockerhub\_credentials) | terraform-aws-modules/secrets-manager/aws | ~> 1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_example_docker_pull_commands"></a> [example\_docker\_pull\_commands](#output\_example\_docker\_pull\_commands) | Example docker pull commands to test and validate the example |
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | IAM role ARN |
| <a name="output_iam_role_name"></a> [iam\_role\_name](#output\_iam\_role\_name) | IAM role name |
| <a name="output_iam_role_unique_id"></a> [iam\_role\_unique\_id](#output\_iam\_role\_unique\_id) | Stable and unique string identifying the IAM role |
<!-- END_TF_DOCS -->

Apache-2.0 Licensed. See [LICENSE](https://github.com/terraform-aws-modules/terraform-aws-ecr/blob/master/LICENSE).
