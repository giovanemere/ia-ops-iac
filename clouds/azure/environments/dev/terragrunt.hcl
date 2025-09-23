terraform {
  source = "../../modules"
}

locals {
  environment = "dev"
  azure_region = "East US"
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
  azure_region = local.azure_region
  project_name = local.project_name
  
  # AKS Configuration
  aks_node_vm_size = "Standard_B2s"
  aks_node_count   = 2
  aks_max_count    = 4
  aks_min_count    = 1
  
  # Monitoring
  enable_monitoring = true
  
  # Common tags
  common_tags = local.common_tags
}

remote_state {
  backend = "azurerm"
  config = {
    resource_group_name  = "billpay-terraform-state"
    storage_account_name = "billpayterraformstate"
    container_name       = "tfstate"
    key                  = "billpay/dev/terraform.tfstate"
  }
}
