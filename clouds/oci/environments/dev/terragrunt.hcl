terraform {
  source = "../../modules"
}

locals {
  environment = "dev"
  oci_region = "us-ashburn-1"
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
  oci_region  = local.oci_region
  project_name = local.project_name
  
  # OKE Configuration
  oke_node_shape = "VM.Standard.E3.Flex"
  oke_node_count = 2
  oke_max_count  = 4
  oke_min_count  = 1
  
  # Monitoring
  enable_monitoring = true
  
  # Common tags
  common_tags = local.common_tags
}

remote_state {
  backend = "s3"
  config = {
    bucket                      = "billpay-terraform-state-oci-dev"
    key                         = "billpay/dev/terraform.tfstate"
    region                      = "us-ashburn-1"
    endpoint                    = "https://namespace.compat.objectstorage.us-ashburn-1.oraclecloud.com"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style           = true
  }
}
