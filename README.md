# AWS CLI Secure Infrastructure Setup

Welcome to the AWS CLI Secure Infrastructure Setup project.  
This repository provides a step-by-step, phase-based approach to building a secure AWS infrastructure using shell scripts and AWS CLI.

Each phase focuses on a key part of the infrastructure, documented and scripted separately for clarity and modularity.

---

## Project Phases and Documentation

| Phase | Description                             | Folder                 |
|-------|---------------------------------------|------------------------|
| 01    | VPC and Subnet Setup                   | [01-vpc-subnet](01-vpc-subnet/README.md)        |
| 02    | Routing and NAT Gateway Configuration  | [02-routing-nat](02-routing-nat/README.md)      |
| 03    | Security Groups Setup                   | [03-security-groups](03-security-groups/README.md) |
| 04    | EC2 Instance Launch with User Data     | [04-ec2-launch](04-ec2-launch/README.md)        |
| 05    | Cleanup Scripts and Teardown            | [05-cleanup](05-cleanup/README.md)               |

---

## How to Use This Repository

- Start with Phase 01 to create your VPC and subnets.
- Progress sequentially through each phase to build out routing, security, instances, and finally clean-up.
- Each phase contains:
  - Detailed README.md with instructions.
  - Executable shell scripts under the `scripts/` directory.
  
---

## Prerequisites

- AWS CLI installed and configured with appropriate credentials.
- Bash shell environment.
- AWS IAM permissions to create VPCs, subnets, route tables, gateways, security groups, and EC2 instances.

---

## Contribution and Support

Feel free to raise issues or contribute improvements via pull requests.

---
=======
# aws-cli-secure-infra
>>>>>>> e94b1d12b11a3db431c75841ac5e6e36d52c53de
