# Phase 2: Routing and NAT Gateway Setup

## Overview

This phase sets up the Internet Gateway (IGW), Public and Private Route Tables, and a NAT Gateway to enable secure internet connectivity for your VPC subnets.

## Objectives

- Attach IGW to VPC for internet access from public subnet.
- Create Public Route Table linked to IGW.
- Allocate Elastic IP and create NAT Gateway in the public subnet.
- Create Private Route Table routing internet-bound traffic through NAT Gateway.
- Associate private subnet with Private Route Table.

## Prerequisites

- Completion of Phase 1 (VPC and subnets created).
- AWS CLI configured with sufficient permissions.

## How to Run

```bash
chmod +x scripts/setup-routing.sh
./scripts/setup-routing.sh
