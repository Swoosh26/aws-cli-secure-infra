#!/bin/bash

set -e

echo "🚀 Starting Routing and NAT Gateway Setup..."

# Load VPC and Subnet IDs from Phase 1 output
VPC_ID=$(aws ec2 describe-vpcs \
  --filters Name=cidr,Values=10.0.0.0/20 \
  --query 'Vpcs[0].VpcId' \
  --output text)

PUBLIC_SUBNET_ID=$(aws ec2 describe-subnets \
  --filters "Name=cidr-block,Values=10.0.0.0/26" "Name=vpc-id,Values=$VPC_ID" \
  --query 'Subnets[0].SubnetId' \
  --output text)

PRIVATE_SUBNET_ID=$(aws ec2 describe-subnets \
  --filters "Name=cidr-block,Values=10.0.1.0/26" "Name=vpc-id,Values=$VPC_ID" \
  --query 'Subnets[0].SubnetId' \
  --output text)

# --- Create Internet Gateway ---
echo "🌐 Creating Internet Gateway..."
IGW_ID=$(aws ec2 create-internet-gateway \
  --query 'InternetGateway.InternetGatewayId' \
  --output text)
echo "✅ Internet Gateway created: $IGW_ID"

# Attach Internet Gateway to VPC
echo "🔗 Attaching Internet Gateway to VPC $VPC_ID..."
aws ec2 attach-internet-gateway \
  --internet-gateway-id "$IGW_ID" \
  --vpc-id "$VPC_ID"

# --- Create Public Route Table ---
echo "🧭 Creating Public Route Table..."
PUBLIC_RT_ID=$(aws ec2 create-route-table \
  --vpc-id "$VPC_ID" \
  --query 'RouteTable.RouteTableId' \
  --output text)
echo "✅ Public Route Table created: $PUBLIC_RT_ID"

# Create Route to Internet Gateway
echo "🌍 Adding route to 0.0.0.0/0 via Internet Gateway..."
aws ec2 create-route \
  --route-table-id "$PUBLIC_RT_ID" \
  --destination-cidr-block 0.0.0.0/0 \
  --gateway-id "$IGW_ID"

# Associate Public Subnet with Public Route Table
echo "🔁 Associating Public Subnet $PUBLIC_SUBNET_ID with Public Route Table..."
aws ec2 associate-route-table \
  --subnet-id "$PUBLIC_SUBNET_ID" \
  --route-table-id "$PUBLIC_RT_ID"

# --- Allocate Elastic IP ---
echo "📡 Allocating Elastic IP for NAT Gateway..."
EIP_ALLOC_ID=$(aws ec2 allocate-address \
  --domain vpc \
  --query 'AllocationId' \
  --output text)
echo "✅ Elastic IP allocated: $EIP_ALLOC_ID"

# --- Create NAT Gateway in Public Subnet ---
echo "🛠️ Creating NAT Gateway in Public Subnet $PUBLIC_SUBNET_ID..."
NAT_GW_ID=$(aws ec2 create-nat-gateway \
  --subnet-id "$PUBLIC_SUBNET_ID" \
  --allocation-id "$EIP_ALLOC_ID" \
  --query 'NatGateway.NatGatewayId' \
  --output text)
echo "🕒 Waiting for NAT Gateway ($NAT_GW_ID) to become available..."
aws ec2 wait nat-gateway-available \
  --nat-gateway-ids "$NAT_GW_ID"
echo "✅ NAT Gateway is available: $NAT_GW_ID"

# --- Create Private Route Table ---
echo "🛡️ Creating Private Route Table..."
PRIVATE_RT_ID=$(aws ec2 create-route-table \
  --vpc-id "$VPC_ID" \
  --query 'RouteTable.RouteTableId' \
  --output text)
echo "✅ Private Route Table created: $PRIVATE_RT_ID"

# Route 0.0.0.0/0 via NAT Gateway
echo "🧭 Creating default route via NAT Gateway in Private Route Table..."
aws ec2 create-route \
  --route-table-id "$PRIVATE_RT_ID" \
  --destination-cidr-block 0.0.0.0/0 \
  --nat-gateway-id "$NAT_GW_ID"

# Associate Private Subnet with Private Route Table
echo "🔁 Associating Private Subnet $PRIVATE_SUBNET_ID with Private Route Table..."
aws ec2 associate-route-table \
  --subnet-id "$PRIVATE_SUBNET_ID" \
  --route-table-id "$PRIVATE_RT_ID"

echo "✅ Phase 2 Complete: Routing and NAT Gateway configured successfully."
