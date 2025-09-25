#!/bin/bash

# Script para configurar permisos públicos de S3 para website hosting
# Uso: ./configure-s3-website.sh PROJECT_NAME ENVIRONMENT

set -e

PROJECT_NAME=${1:-"billpay-demo"}
ENVIRONMENT=${2:-"dev"}
REGION=${3:-"us-east-1"}

echo "🌐 Configurando S3 buckets para website hosting público..."
echo "📋 Project: $PROJECT_NAME"
echo "🌍 Environment: $ENVIRONMENT"
echo "🌎 Region: $REGION"
echo ""

# Lista de buckets frontend
BUCKETS=(
    "$PROJECT_NAME-$ENVIRONMENT-frontend-a"
    "$PROJECT_NAME-$ENVIRONMENT-frontend-b"
    "$PROJECT_NAME-$ENVIRONMENT-frontend-feature-flags"
)

for BUCKET in "${BUCKETS[@]}"; do
    echo "🗄️ Configurando bucket: $BUCKET"
    
    # 1. Remover bloqueo de acceso público
    echo "  🔓 Removiendo bloqueo de acceso público..."
    aws s3api put-public-access-block \
        --bucket "$BUCKET" \
        --public-access-block-configuration \
        "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false" \
        --region "$REGION" || echo "  ⚠️ Bucket no existe o ya configurado"
    
    # 2. Habilitar website hosting
    echo "  🌐 Habilitando website hosting..."
    aws s3 website "s3://$BUCKET" \
        --index-document index.html \
        --error-document error.html \
        --region "$REGION" || echo "  ⚠️ Error configurando website"
    
    # 3. Aplicar política de bucket público
    echo "  📋 Aplicando política de acceso público..."
    cat > /tmp/bucket-policy.json << EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::$BUCKET/*"
        }
    ]
}
EOF
    
    aws s3api put-bucket-policy \
        --bucket "$BUCKET" \
        --policy file:///tmp/bucket-policy.json \
        --region "$REGION" || echo "  ⚠️ Error aplicando política"
    
    # 4. Configurar CORS
    echo "  🔗 Configurando CORS..."
    cat > /tmp/cors-config.json << EOF
{
    "CORSRules": [
        {
            "AllowedHeaders": ["*"],
            "AllowedMethods": ["GET", "HEAD"],
            "AllowedOrigins": ["*"],
            "ExposeHeaders": ["ETag"],
            "MaxAgeSeconds": 3000
        }
    ]
}
EOF
    
    aws s3api put-bucket-cors \
        --bucket "$BUCKET" \
        --cors-configuration file:///tmp/cors-config.json \
        --region "$REGION" || echo "  ⚠️ Error configurando CORS"
    
    echo "  ✅ Bucket $BUCKET configurado"
    echo "  🌐 URL: http://$BUCKET.s3-website-$REGION.amazonaws.com"
    echo ""
done

# Limpiar archivos temporales
rm -f /tmp/bucket-policy.json /tmp/cors-config.json

echo "✅ Configuración S3 completada!"
echo ""
echo "🌐 URLs de los websites:"
for BUCKET in "${BUCKETS[@]}"; do
    echo "  - $BUCKET: http://$BUCKET.s3-website-$REGION.amazonaws.com"
done
echo ""
echo "💡 Los buckets ahora son accesibles públicamente para website hosting"
