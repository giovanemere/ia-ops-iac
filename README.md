# BillPay Infrastructure as Code - Multi-Cloud

Repositorio de infraestructura multi-cloud para el proyecto BillPay usando OpenTofu + Terragrunt.

## 🌐 Estructura Multi-Cloud

```
ia-ops-iac/
├── clouds/                    # Configuraciones específicas por cloud
│   ├── aws/                   # Amazon Web Services
│   │   ├── environments/      # dev, staging, prod
│   │   └── modules/          # VPC, EKS, ECR, S3, ALB
│   ├── gcp/                   # Google Cloud Platform
│   │   ├── environments/      # dev, staging, prod
│   │   └── modules/          # VPC, GKE, Container Registry, Cloud Storage
│   ├── azure/                 # Microsoft Azure
│   │   ├── environments/      # dev, staging, prod
│   │   └── modules/          # VNet, AKS, Container Registry, Storage
│   └── oci/                   # Oracle Cloud Infrastructure
│       ├── environments/      # dev, staging, prod
│       └── modules/          # VCN, OKE, Container Registry, Object Storage
└── shared/                    # Recursos compartidos
    ├── modules/               # Módulos reutilizables entre clouds
    ├── scripts/               # Scripts de automatización
    └── templates/             # Templates Backstage
```

## ☁️ Clouds Soportados

### 🟠 AWS (Amazon Web Services)
- **Compute**: EKS (Kubernetes)
- **Storage**: S3 + CloudFront
- **Registry**: ECR
- **Network**: VPC + ALB
- **Environments**: dev, staging, prod

### 🔵 GCP (Google Cloud Platform)
- **Compute**: GKE (Kubernetes)
- **Storage**: Cloud Storage + CDN
- **Registry**: Container Registry
- **Network**: VPC + Load Balancer
- **Environments**: dev, staging, prod

### 🟦 Azure (Microsoft Azure)
- **Compute**: AKS (Kubernetes)
- **Storage**: Storage Account + CDN
- **Registry**: Container Registry
- **Network**: VNet + Application Gateway
- **Environments**: dev, staging, prod

### 🔴 OCI (Oracle Cloud Infrastructure)
- **Compute**: OKE (Kubernetes)
- **Storage**: Object Storage + CDN
- **Registry**: Container Registry
- **Network**: VCN + Load Balancer
- **Environments**: dev, staging, prod

## 🚀 Uso desde Backstage

1. Ir a Backstage: `http://localhost:3000`
2. Create → "BillPay Infrastructure"
3. Seleccionar **cloud provider** (AWS/GCP/Azure/OCI)
4. Seleccionar **environment** (dev/staging/prod)
5. Deploy automático

## 💰 Costos Estimados por Cloud

### AWS
- **Dev**: $170-265/mes
- **Staging**: $200-300/mes  
- **Prod**: $300-450/mes

### GCP
- **Dev**: $150-240/mes
- **Staging**: $180-280/mes
- **Prod**: $280-420/mes

### Azure
- **Dev**: $160-250/mes
- **Staging**: $190-290/mes
- **Prod**: $290-440/mes

### OCI
- **Dev**: $140-220/mes
- **Staging**: $170-260/mes
- **Prod**: $260-400/mes

## 🛠️ Deploy Manual

```bash
# AWS
cd clouds/aws/environments/dev
terragrunt plan && terragrunt apply

# GCP
cd clouds/gcp/environments/dev
terragrunt plan && terragrunt apply

# Azure
cd clouds/azure/environments/dev
terragrunt plan && terragrunt apply

# OCI
cd clouds/oci/environments/dev
terragrunt plan && terragrunt apply
```

## 🎯 Recursos Desplegados (Todos los Clouds)

- **Kubernetes Cluster** (EKS/GKE/AKS/OKE)
- **Container Registry** (4 repositorios)
- **Frontend Hosting** (3 frontends con CDN)
- **Load Balancer** (Application/Network)
- **Networking** (VPC/VNet/VCN completo)
- **Monitoring** (CloudWatch/Stackdriver/Monitor/Monitoring)
