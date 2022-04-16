################################################################################
# Repository (Public and Private)
################################################################################

output "repository_arn" {
  description = "Full ARN of the repository"
  value       = try(aws_ecr_repository.this[0].arn, aws_ecrpublic_repository.this[0].arn, null)
}

output "repository_registry_id" {
  description = "The registry ID where the repository was created"
  value       = try(aws_ecr_repository.this[0].registry_id, aws_ecrpublic_repository.this[0].registry_id, null)
}

output "repository_url" {
  description = "The URL of the repository"
  value       = try(aws_ecr_repository.this[0].repository_url, aws_ecrpublic_repository.this[0].repository_uri, null)
}
