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
