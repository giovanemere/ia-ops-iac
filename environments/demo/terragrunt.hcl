# Terragrunt configuration for demo environment

terraform {
  source = "../../clouds/aws/modules/frontend-hosting"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  environment = "demo"
  project_name = get_env("PROJECT_NAME", "billpay")
  
  # S3 Website configuration
  bucket_name = "${get_env("PROJECT_NAME", "billpay")}-demo-frontend-a"
  
  # Tags
  tags = {
    Environment = "demo"
    Project     = get_env("PROJECT_NAME", "billpay")
    ManagedBy   = "terragrunt"
  }
}
