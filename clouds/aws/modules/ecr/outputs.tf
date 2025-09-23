output "repository_urls" {
  description = "URLs de los repositorios ECR"
  value       = { for k, v in aws_ecr_repository.repositories : k => v.repository_url }
}

output "repository_arns" {
  description = "ARNs de los repositorios ECR"
  value       = { for k, v in aws_ecr_repository.repositories : k => v.arn }
}
