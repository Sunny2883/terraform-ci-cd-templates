# Project Overview

This repository provides a reusable template for deploying cloud infrastructure on AWS, along with CI/CD pipelines for both frontend and backend applications.

---

## Infrastructure Details

### Cloud Provider
- **AWS**

### Applications
- **Frontend**: React (Deployed in S3)
- **Backend**: .NET API (Deployed in ECS)
- **Database**: PostgreSQL (RDS)
- **Logs**: CloudWatch

---

## Resources Created Using Terraform
The following resources will be created using Terraform:
- VPC with Public and Private Subnets
- IAM Role
- Security Group
- CloudFront
- S3 Bucket
- Application Load Balancer
- ECS Cluster (with EC2 and Fargate Launch Types)
- ECS Services with Auto Scaling
- RDS

---

## Conditions
You can customize the following options during deployment:
- **EC2 Launch Types**:
  - EC2
  - Fargate

- **VPC Options**:
  - VPC with Public and Private Subnets
  - VPC with Public, Private, and Private with Internet Access (NAT Gateway)
  - Public and Private with Internet Access (NAT Gateway)

- **RDS Configuration**:
  - **Public**: Created in the public subnet.
  - **Private**: Options for private subnet or private with internet access subnet.

---

## CI/CD Pipeline

The CI/CD pipeline templates for the frontend (React) and backend (.NET API) applications are located in the `pipeline` folder.

---

## Workflow Configuration

1. **Modify `main.tf`**: Edit the file in the root folder to customize the infrastructure setup.
2. **Add GitHub Secrets**: Ensure all necessary values for CI/CD operations are added to your GitHub Secrets.
3. **Run Workflows**: Trigger the respective workflow files to deploy the applications.

---

## How to Use

- For **Infrastructure Setup**:
  1. Edit `main.tf` as needed.
  2. Apply it using Terraform.

- For **CI/CD**:
  1. Configure GitHub Secrets.
  2. Trigger the workflows to deploy the applications.

---
