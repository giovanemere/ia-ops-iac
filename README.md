# BillPay Infrastructure as Code

Repositorio de infraestructura para el proyecto BillPay usando OpenTofu + Terragrunt.

## Estructura

```
ia-ops-iac/
├── environments/          # Configuraciones por ambiente
│   ├── dev/              # Desarrollo
│   ├── staging/          # Staging  
│   └── prod/             # Producción
├── modules/              # Módulos OpenTofu reutilizables
│   ├── vpc/              # VPC + Networking
│   ├── eks/              # EKS Cluster
│   ├── ecr/              # ECR Repositories
│   ├── frontend-hosting/ # S3 + CloudFront
│   └── alb/              # Application Load Balancer
└── scripts/              # Scripts de automatización
```

## Recursos Desplegados

- **VPC**: 10.0.0.0/16 con subnets públicas y privadas
- **EKS Cluster**: Para microservicios backend
- **ECR Repositories**: 4 repositorios para imágenes Docker
- **S3 + CloudFront**: Hosting para 3 frontends Angular
- **Application Load Balancer**: Balanceador de carga

## Uso desde Backstage

1. Ir a Backstage: `http://localhost:3000`
2. Create → "BillPay Infrastructure"
3. Seleccionar environment (dev/staging/prod)
4. Deploy automático

## Costos Estimados

- **Dev**: $170-265/mes
- **Staging**: $200-300/mes  
- **Prod**: $300-450/mes
