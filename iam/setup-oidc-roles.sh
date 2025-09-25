#!/bin/bash

# 🔐 Setup OIDC Roles for GitHub Actions - BillPay Platform

echo "🔐 CONFIGURANDO ROLES OIDC PARA GITHUB ACTIONS"
echo "=============================================="

# Variables
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ROLE_NAME="BillPayGitHubActionsRole"
POLICY_NAME="BillPayDeploymentPolicy"
OIDC_PROVIDER="token.actions.githubusercontent.com"

echo "📋 Account ID: $ACCOUNT_ID"
echo "🏷️ Role Name: $ROLE_NAME"
echo ""

# 1. Crear OIDC Provider si no existe
echo "🔗 Configurando OIDC Provider..."
if ! aws iam get-open-id-connect-provider --open-id-connect-provider-arn "arn:aws:iam::$ACCOUNT_ID:oidc-provider/$OIDC_PROVIDER" 2>/dev/null; then
    echo "📝 Creando OIDC Provider..."
    aws iam create-open-id-connect-provider \
        --url "https://$OIDC_PROVIDER" \
        --thumbprint-list 6938fd4d98bab03faadb97b34396831e3780aea1 \
        --client-id-list sts.amazonaws.com
    echo "✅ OIDC Provider creado"
else
    echo "✅ OIDC Provider ya existe"
fi

# 2. Crear Trust Policy
echo "📋 Creando Trust Policy..."
cat > trust-policy.json << EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::$ACCOUNT_ID:oidc-provider/$OIDC_PROVIDER"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": [
            "repo:giovanemere/ia-ops-iac:*",
            "repo:giovanemere/poc-billpay-*:*"
          ]
        }
      }
    }
  ]
}
EOF

# 3. Crear Deployment Policy
echo "📋 Creando Deployment Policy..."
cat > deployment-policy.json << EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:CreateBucket",
        "s3:DeleteBucket",
        "s3:GetBucketLocation",
        "s3:GetBucketWebsite",
        "s3:PutBucketWebsite",
        "s3:PutBucketPolicy",
        "s3:PutBucketAcl",
        "s3:PutBucketPublicAccessBlock",
        "s3:GetBucketPublicAccessBlock",
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::*billpay*",
        "arn:aws:s3:::*billpay*/*",
        "arn:aws:s3:::*demo*",
        "arn:aws:s3:::*demo*/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "cloudfront:CreateDistribution",
        "cloudfront:GetDistribution",
        "cloudfront:UpdateDistribution",
        "cloudfront:DeleteDistribution",
        "cloudfront:CreateInvalidation",
        "cloudfront:ListDistributions"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "sts:GetCallerIdentity"
      ],
      "Resource": "*"
    }
  ]
}
EOF

# 4. Crear Role
echo "🎭 Creando IAM Role..."
if aws iam create-role \
    --role-name "$ROLE_NAME" \
    --assume-role-policy-document file://trust-policy.json \
    --description "Role for BillPay GitHub Actions deployments"; then
    echo "✅ Role creado: $ROLE_NAME"
else
    echo "ℹ️ Role ya existe, actualizando trust policy..."
    aws iam update-assume-role-policy \
        --role-name "$ROLE_NAME" \
        --policy-document file://trust-policy.json
fi

# 5. Crear y adjuntar Policy
echo "📎 Creando y adjuntando Policy..."
if aws iam create-policy \
    --policy-name "$POLICY_NAME" \
    --policy-document file://deployment-policy.json \
    --description "Policy for BillPay deployments"; then
    echo "✅ Policy creada: $POLICY_NAME"
else
    echo "ℹ️ Policy ya existe"
fi

# Adjuntar policy al role
aws iam attach-role-policy \
    --role-name "$ROLE_NAME" \
    --policy-arn "arn:aws:iam::$ACCOUNT_ID:policy/$POLICY_NAME"

echo "✅ Policy adjuntada al role"

# 6. Mostrar información del role
echo ""
echo "🎉 CONFIGURACIÓN COMPLETADA"
echo "=========================="
echo "🏷️ Role ARN: arn:aws:iam::$ACCOUNT_ID:role/$ROLE_NAME"
echo "📋 Policy ARN: arn:aws:iam::$ACCOUNT_ID:policy/$POLICY_NAME"
echo ""
echo "📝 Agregar a GitHub Secrets:"
echo "AWS_ROLE_ARN=arn:aws:iam::$ACCOUNT_ID:role/$ROLE_NAME"
echo ""
echo "🔄 Próximo paso: Actualizar workflows para usar OIDC"

# Cleanup
rm -f trust-policy.json deployment-policy.json
