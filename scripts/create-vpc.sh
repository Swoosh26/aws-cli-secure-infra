#!/bin/bash

set -euo pipefail

echo "Starting VPC and subnet creation..."

# Variables (customize these or read from env/config file)
AWS_REGION="us-west-2"
VPC_CIDR="10.0.0.0/20"
PUBLIC_SUBNET_CIDR="10.0.0.0/26"
PRIVATE_SUBNET_CIDR="10.0.1.0/26"
AVAILABILITY_ZONE="${AWS_REGION}a"

# Create VPC
echo "Creating VPC with CIDR $VPC_CIDR..."
VPC_ID=$(aws ec2 create-vpc --cidr-block $VPC_CIDR \
  --tag-specifications "ResourceType=vpc,Tags=[{Key=Name,Value=aws-cli-vpc}]" \
  --query 'Vpc.VpcId' --output text --region $AWS_REGION)

echo "VPC created: $VPC_ID"

# Enable DNS support & hostnames
aws ec2 modify-vpc-attribute --vpc-id $VPC_ID --enable-dns-support "{\"Value\":true}" --region $AWS_REGION
aws ec2 modify-vpc-attribute --vpc-id $VPC_ID --enable-dns-hostnames "{\"Value\":true}" --region $AWS_REGION
echo "Enabled DNS support and hostnames for VPC"

# Create Public Subnet
echo "Creating Public Subnet $PUBLIC_SUBNET_CIDR in $AVAILABILITY_ZONE..."
PUBLIC_SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $PUBLIC_SUBNET_CIDR \
  --availability-zone $AVAILABILITY_ZONE \
  --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=Public Subnet}]" \
  --query 'Subnet.SubnetId' --output text --region $AWS_REGION)

echo "Public Subnet created: $PUBLIC_SUBNET_ID"

# Enable Auto-assign Public IP on Public Subnet
aws ec2 modify-subnet-attribute --subnet-id $PUBLIC_SUBNET_ID --map-public-ip-on-launch --region $AWS_REGION
echo "Enabled Auto-assign Public IP on Public Subnet"

# Create Private Subnet
echo "Creating Private Subnet $PRIVATE_SUBNET_CIDR in $AVAILABILITY_ZONE..."
PRIVATE_SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $PRIVATE_SUBNET_CIDR \
  --availability-zone $AVAILABILITY_ZONE \
  --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=Private Subnet}]" \
  --query 'Subnet.SubnetId' --output text --region $AWS_REGION)

echo "Private Subnet created: $PRIVATE_SUBNET_ID"

echo "VPC and Subnets creation completed."
echo "VPC ID: $VPC_ID"
echo "Public Subnet ID: $PUBLIC_SUBNET_ID"
echo "Private Subnet ID: $PRIVATE_SUBNET_ID"
