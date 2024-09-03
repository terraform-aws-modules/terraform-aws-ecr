module "wrapper" {
  source = "../../modules/repository-template"

  for_each = var.items

  applied_for                        = try(each.value.applied_for, var.defaults.applied_for, ["PULL_THROUGH_CACHE"])
  create                             = try(each.value.create, var.defaults.create, true)
  create_iam_role                    = try(each.value.create_iam_role, var.defaults.create_iam_role, true)
  create_pull_through_cache_rule     = try(each.value.create_pull_through_cache_rule, var.defaults.create_pull_through_cache_rule, false)
  create_repository_policy           = try(each.value.create_repository_policy, var.defaults.create_repository_policy, true)
  credential_arn                     = try(each.value.credential_arn, var.defaults.credential_arn, null)
  custom_role_arn                    = try(each.value.custom_role_arn, var.defaults.custom_role_arn, null)
  description                        = try(each.value.description, var.defaults.description, null)
  encryption_type                    = try(each.value.encryption_type, var.defaults.encryption_type, "AES256")
  iam_role_description               = try(each.value.iam_role_description, var.defaults.iam_role_description, null)
  iam_role_name                      = try(each.value.iam_role_name, var.defaults.iam_role_name, null)
  iam_role_path                      = try(each.value.iam_role_path, var.defaults.iam_role_path, null)
  iam_role_permissions_boundary      = try(each.value.iam_role_permissions_boundary, var.defaults.iam_role_permissions_boundary, null)
  iam_role_tags                      = try(each.value.iam_role_tags, var.defaults.iam_role_tags, {})
  iam_role_use_name_prefix           = try(each.value.iam_role_use_name_prefix, var.defaults.iam_role_use_name_prefix, true)
  image_tag_mutability               = try(each.value.image_tag_mutability, var.defaults.image_tag_mutability, "IMMUTABLE")
  kms_key_arn                        = try(each.value.kms_key_arn, var.defaults.kms_key_arn, null)
  lifecycle_policy                   = try(each.value.lifecycle_policy, var.defaults.lifecycle_policy, null)
  prefix                             = try(each.value.prefix, var.defaults.prefix, "")
  repository_lambda_read_access_arns = try(each.value.repository_lambda_read_access_arns, var.defaults.repository_lambda_read_access_arns, [])
  repository_policy                  = try(each.value.repository_policy, var.defaults.repository_policy, null)
  repository_policy_statements       = try(each.value.repository_policy_statements, var.defaults.repository_policy_statements, {})
  repository_read_access_arns        = try(each.value.repository_read_access_arns, var.defaults.repository_read_access_arns, [])
  repository_read_write_access_arns  = try(each.value.repository_read_write_access_arns, var.defaults.repository_read_write_access_arns, [])
  resource_tags                      = try(each.value.resource_tags, var.defaults.resource_tags, {})
  tags                               = try(each.value.tags, var.defaults.tags, {})
  upstream_registry_url              = try(each.value.upstream_registry_url, var.defaults.upstream_registry_url, null)
}
