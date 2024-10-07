Project Overview
This repository provides a reusable template for deploying a cloud infrastructure on AWS, along with CI/CD pipelines for both frontend and backend applications.

Infrastructure Details
Cloud: AWS
Frontend: React (Deployed in S3)
Backend: .NET API (Deployed in ECS)
Database: PostgreSQL (RDS)
Logs: CloudWatch
Resources Created Using Terraform
VPC with Public and Private Subnets
IAM Role
Security Group
CloudFront
S3 Bucket
Application Load Balancer
ECS Cluster (with EC2 and Fargate Launch Types)
ECS Services with Auto Scaling
RDS
Conditions
Select EC2 Launch Types between EC2 and Fargate.
Choose between:
VPC with Public and Private Subnets
VPC with Public, Private, and Private with Internet Access (NAT Gateway)
Public and Private with Internet Access (NAT Gateway)
RDS configuration:
Public: Created in the public subnet.
Private: Options for private subnet or private with internet access subnet.
CI/CD Pipeline
The CI/CD pipeline templates for the frontend (React) and backend (.NET API) applications are located in the pipeline folder.

Workflow Configuration
Modify the main.tf file in the root folder to customize the infrastructure setup.
Add necessary values to the GitHub Secrets for CI/CD operations.
Run the respective workflow files to deploy the applications.
How to Use
For infrastructure setup, edit main.tf as needed and apply it using Terraform.
For CI/CD, ensure GitHub Secrets are configured, and trigger the workflows.