terraform {
  source = "../../modules"
}

locals {
  environment = "staging"
  aws_region  = "us-east-1"
  project_name = "billpay"
  
  common_tags = {
    Project     = "BillPay"
    Environment = local.environment
    ManagedBy   = "Terragrunt"
    CreatedBy   = "Backstage"
  }
}

inputs = {
  environment = local.environment
  aws_region  = local.aws_region
  project_name = local.project_name
  
  # EKS Configuration
  eks_node_instance_type = "t3.medium"
  eks_node_desired_size  = 2
  eks_node_max_size      = 4
  eks_node_min_size      = 1
  
  # Monitoring
  enable_monitoring = true
  
  # Common tags
  common_tags = local.common_tags
}

remote_state {
  backend = "s3"
  config = {
    bucket         = "billpay-terraform-state-dev"
    key            = "billpay/dev/terraform.tfstate"
    region         = local.aws_region
    encrypt        = true
    dynamodb_table = "billpay-terraform-locks-dev"
  }
}
