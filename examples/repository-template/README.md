# Amazon ECR Repository Template Example

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

You can validate this example by running the following commands:

```bash
# Ensure your local CLI is authenticated with ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.us-east-1.amazonaws.com

# Dockerhub pull through cache and repo creation
docker pull <account-id>.dkr.ecr.us-east-1.amazonaws.com/dockerhub/library/nginx:latest

# Public ECR pull through cache and repo creation
docker pull <account-id>.dkr.ecr.us-east-1.amazonaws.com/public-ecr/docker/library/nginx:latest
```

Note that this example may create resources which will incur monetary charges on your AWS bill. Run `terraform destroy` when you no longer need these resources.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.61 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.61 |

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

No outputs.
<!-- END_TF_DOCS -->

Apache-2.0 Licensed. See [LICENSE](https://github.com/terraform-aws-modules/terraform-aws-ecr/blob/master/LICENSE).
