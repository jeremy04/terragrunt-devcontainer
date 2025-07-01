#!/bin/bash

# LocalStack initialization script
# This script sets up AWS resources in LocalStack for development

echo "Initializing LocalStack resources..."

# Create S3 bucket
echo "Creating S3 bucket: my-bucket"
aws --endpoint-url=http://localhost:4566 s3 mb s3://my-bucket

# Create IAM role for Terraform
echo "Creating IAM role: TerraformRole"

# Create trust policy for the role
cat > trust-policy.json << 'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::123456789012:root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

# Create the IAM role
aws --endpoint-url=http://localhost:4566 iam create-role \
  --role-name TerraformRole \
  --assume-role-policy-document file://trust-policy.json

# Attach administrator access policy to the role
aws --endpoint-url=http://localhost:4566 iam attach-role-policy \
  --role-name TerraformRole \
  --policy-arn arn:aws:iam::aws:policy/AdministratorAccess

# Clean up temporary file
rm trust-policy.json

echo "LocalStack initialization complete!"
echo "IAM Role ARN: arn:aws:iam::123456789012:role/TerraformRole"
echo "S3 Bucket: my-bucket"