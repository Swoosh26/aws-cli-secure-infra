# Phase 1: VPC and Subnet Setup

This phase creates the VPC and its public and private subnets.

- Creates a new VPC with CIDR 10.0.0.0/20
- Creates one public subnet (10.0.0.0/26)
- Creates one private subnet (10.0.64.0/26)
- Enables public IP assignment on the public subnet

The script for this phase is located at `scripts/create-vpc.sh`.
