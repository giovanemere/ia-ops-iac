#!/bin/bash

# 🔄 Update existing IAM Policy for S3 Public Access Block

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
POLICY_NAME="BillPayDeploymentPolicy"
POLICY_ARN="arn:aws:iam::$ACCOUNT_ID:policy/$POLICY_NAME"

echo "🔄 Updating IAM Policy: $POLICY_NAME"

# Create updated policy document
cat > updated-deployment-policy.json << EOF
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

# Create new policy version
echo "📝 Creating new policy version..."
aws iam create-policy-version \
    --policy-arn "$POLICY_ARN" \
    --policy-document file://updated-deployment-policy.json \
    --set-as-default

echo "✅ Policy updated successfully!"
echo "🔐 New permissions added:"
echo "  - s3:PutBucketPublicAccessBlock"
echo "  - s3:GetBucketPublicAccessBlock"

# Cleanup
rm -f updated-deployment-policy.json
