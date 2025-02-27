################################################################################
# IAM Role
################################################################################

output "iam_role_name" {
  description = "IAM role name"
  value       = try(aws_iam_role.this[0].name, null)
}

output "iam_role_arn" {
  description = "IAM role ARN"
  value       = try(aws_iam_role.this[0].arn, var.custom_role_arn)
}

output "iam_role_unique_id" {
  description = "Stable and unique string identifying the IAM role"
  value       = try(aws_iam_role.this[0].unique_id, null)
}

output "prefix" {
  description = "The repository name prefix"
  value       = var.prefix
}

output "upstream_registry_url" {
  description = "The registry URL of the upstream public registry to use as the source for the pull through cache rule"
  value       = var.upstream_registry_url
}

output "create_pull_through_cache_rule" {
  description = "Determines whether a pull through cache rule will be created"
  value       = var.create && var.create_pull_through_cache_rule
}
