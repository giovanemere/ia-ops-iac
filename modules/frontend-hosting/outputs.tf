output "s3_bucket_names" {
  description = "Nombres de los buckets S3"
  value       = { for k, v in aws_s3_bucket.frontend : k => v.id }
}

output "cloudfront_urls" {
  description = "URLs de las distribuciones CloudFront"
  value       = { for k, v in aws_cloudfront_distribution.frontend : k => "https://${v.domain_name}" }
}
