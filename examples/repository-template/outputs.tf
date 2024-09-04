output "iam_role_name" {
  description = "IAM role name"
  value       = module.dockerhub_pull_through_cache_repository_template.iam_role_name
}

output "iam_role_arn" {
  description = "IAM role ARN"
  value       = module.dockerhub_pull_through_cache_repository_template.iam_role_arn
}

output "iam_role_unique_id" {
  description = "Stable and unique string identifying the IAM role"
  value       = module.public_ecr_pull_through_cache_repository_template.iam_role_unique_id
}

output "example_docker_pull_commands" {
  description = "Example docker pull commands to test and validate the example"
  value       = <<-EOT
    # Ensure your local CLI is authenticated with ECR
    aws ecr get-login-password --region ${local.region} | docker login --username AWS --password-stdin ${local.account_id}.dkr.ecr.${local.region}.amazonaws.com

    # Dockerhub pull through cache and repo creation
    docker pull ${local.account_id}.dkr.ecr.${local.region}.amazonaws.com/docker-hub/library/nginx:latest

    # Public ECR pull through cache and repo creation
    docker pull ${local.account_id}.dkr.ecr.${local.region}.amazonaws.com/ecr-public/docker/library/nginx:latest
  EOT
}
