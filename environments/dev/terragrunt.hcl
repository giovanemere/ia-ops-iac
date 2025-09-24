# Terragrunt configuration for dev environment

terraform {
  source = "../../clouds/aws/modules/frontend-hosting"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  environment = "dev"
  project_name = get_env("PROJECT_NAME", "billpay")
  
  # S3 Website configuration
  bucket_name = "${get_env("PROJECT_NAME", "billpay")}-dev-frontend-a"
  
  # Tags
  tags = {
    Environment = "dev"
    Project     = get_env("PROJECT_NAME", "billpay")
    ManagedBy   = "terragrunt"
  }
}
