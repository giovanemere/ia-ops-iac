terraform {
  source = "../../modules"
}

locals {
  environment = "dev"
  gcp_region  = "us-central1"
  gcp_project = "billpay-dev"
  project_name = "billpay"
  
  common_labels = {
    project     = "billpay"
    environment = local.environment
    managed-by  = "terragrunt"
    created-by  = "backstage"
  }
}

inputs = {
  environment = local.environment
  gcp_region  = local.gcp_region
  gcp_project = local.gcp_project
  project_name = local.project_name
  
  # GKE Configuration
  gke_node_machine_type = "e2-medium"
  gke_node_count        = 2
  gke_max_node_count    = 4
  gke_min_node_count    = 1
  
  # Monitoring
  enable_monitoring = true
  
  # Common labels
  common_labels = local.common_labels
}

remote_state {
  backend = "gcs"
  config = {
    bucket = "billpay-terraform-state-dev"
    prefix = "billpay/dev/terraform.tfstate"
  }
}
