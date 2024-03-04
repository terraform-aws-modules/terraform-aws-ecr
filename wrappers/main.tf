module "wrapper" {
  source = "../"

  for_each = var.items

  attach_repository_policy                  = try(each.value.attach_repository_policy, var.defaults.attach_repository_policy, true)
  create                                    = try(each.value.create, var.defaults.create, true)
  create_lifecycle_policy                   = try(each.value.create_lifecycle_policy, var.defaults.create_lifecycle_policy, true)
  create_registry_policy                    = try(each.value.create_registry_policy, var.defaults.create_registry_policy, false)
  create_registry_replication_configuration = try(each.value.create_registry_replication_configuration, var.defaults.create_registry_replication_configuration, false)
  create_repository                         = try(each.value.create_repository, var.defaults.create_repository, true)
  create_repository_policy                  = try(each.value.create_repository_policy, var.defaults.create_repository_policy, true)
  manage_registry_scanning_configuration    = try(each.value.manage_registry_scanning_configuration, var.defaults.manage_registry_scanning_configuration, false)
  public_repository_catalog_data            = try(each.value.public_repository_catalog_data, var.defaults.public_repository_catalog_data, {})
  registry_policy                           = try(each.value.registry_policy, var.defaults.registry_policy, null)
  registry_pull_through_cache_rules         = try(each.value.registry_pull_through_cache_rules, var.defaults.registry_pull_through_cache_rules, {})
  registry_replication_rules                = try(each.value.registry_replication_rules, var.defaults.registry_replication_rules, [])
  registry_scan_rules                       = try(each.value.registry_scan_rules, var.defaults.registry_scan_rules, [])
  registry_scan_type                        = try(each.value.registry_scan_type, var.defaults.registry_scan_type, "ENHANCED")
  repository_encryption_type                = try(each.value.repository_encryption_type, var.defaults.repository_encryption_type, null)
  repository_force_delete                   = try(each.value.repository_force_delete, var.defaults.repository_force_delete, null)
  repository_image_scan_on_push             = try(each.value.repository_image_scan_on_push, var.defaults.repository_image_scan_on_push, true)
  repository_image_tag_mutability           = try(each.value.repository_image_tag_mutability, var.defaults.repository_image_tag_mutability, "IMMUTABLE")
  repository_kms_key                        = try(each.value.repository_kms_key, var.defaults.repository_kms_key, null)
  repository_lambda_read_access_arns        = try(each.value.repository_lambda_read_access_arns, var.defaults.repository_lambda_read_access_arns, [])
  repository_lifecycle_policy               = try(each.value.repository_lifecycle_policy, var.defaults.repository_lifecycle_policy, "")
  repository_name                           = try(each.value.repository_name, var.defaults.repository_name, "")
  repository_policy                         = try(each.value.repository_policy, var.defaults.repository_policy, null)
  repository_policy_statements              = try(each.value.repository_policy_statements, var.defaults.repository_policy_statements, {})
  repository_read_access_arns               = try(each.value.repository_read_access_arns, var.defaults.repository_read_access_arns, [])
  repository_read_write_access_arns         = try(each.value.repository_read_write_access_arns, var.defaults.repository_read_write_access_arns, [])
  repository_type                           = try(each.value.repository_type, var.defaults.repository_type, "private")
  tags                                      = try(each.value.tags, var.defaults.tags, {})
}
