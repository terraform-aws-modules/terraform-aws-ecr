# Wrapper for the root module

The configuration in this directory contains an implementation of a single module wrapper pattern, which allows managing several copies of a module in places where using the native Terraform 0.13+ `for_each` feature is not feasible (e.g., with Terragrunt).

You may want to use a single Terragrunt configuration file to manage multiple resources without duplicating `terragrunt.hcl` files for each copy of the same module.

This wrapper does not implement any extra functionality.

## Usage with Terragrunt

`terragrunt.hcl`:

```hcl
terraform {
  source = "tfr:///terraform-aws-modules/ecr/aws//wrappers"
  # Alternative source:
  # source = "git::git@github.com:terraform-aws-modules/terraform-aws-ecr.git?ref=master//wrappers"
}

inputs = {
  defaults = { # Default values
    create = true
    tags = {
      Terraform   = "true"
      Environment = "dev"
    }
  }

  items = {
    my-item = {
      # omitted... can be any argument supported by the module
    }
    my-second-item = {
      # omitted... can be any argument supported by the module
    }
    # omitted...
  }
}
```

## Usage with Terraform

```hcl
module "wrapper" {
  source = "terraform-aws-modules/ecr/aws//wrappers"

  defaults = { # Default values
    create = true
    tags = {
      Terraform   = "true"
      Environment = "dev"
    }
  }

  items = {
    my-item = {
      # omitted... can be any argument supported by the module
    }
    my-second-item = {
      # omitted... can be any argument supported by the module
    }
    # omitted...
  }
}
```

## Example: Manage multiple ECR repos in one Terragrunt layer

`eu-west-1/ecr-repos/terragrunt.hcl`:

```hcl
terraform {
  source = "tfr:///terraform-aws-modules/terraform-aws-ecr/aws//wrappers"
  # Alternative source:
  # source = "git::git@github.com:terraform-aws-modules/terraform-aws-ecr.git?ref=master//wrappers"
}

inputs = {
  defaults = {
    create = true

    repository_image_tag_mutability = IMMUTABLE
  }

  items = {
    ecr1 = {
      repository_name = "my-random-ecr-image-1"
    }
    ecr2 = {
      repository_name = "my-random-ecr-image-2"
      tags = {
        Secure = "probably"
      }
    }
  }
}
```
