## 🎯 Overview

This repo contains **Terraform** with **AWS** cloud practise labs with real-world scenario’s.

## 📚 Available Labs

### 1. Static Website Hosting (`1_Host-Static-Website/`)

Deploy a secure, globally distributed static website using S3 and CloudFront CDN.

**Key Features:**

- S3 bucket with Origin Access Control (OAC)
- CloudFront distribution with HTTPS enforcement
- Automated static file uploads with proper MIME types
- Private S3 bucket accessed only through CDN

### 2. IAM User Management (`2_IAM_User_Management/`)

Enterprise-grade identity and access management with automated user provisioning.

**Key Features:**

- Bulk user creation from CSV data
- Department-based IAM groups and policies
- Automated group memberships and access control
- Secure password management with reset requirements

### 3. Serverless Image Processing (`3_Lambda_Image_Processor/`)

Event-driven image processing pipeline using Lambda and S3.

**Key Features:**

- Serverless image processing with multiple format support
- Automatic compression, resizing, and thumbnail generation
- Event-driven architecture with S3 notifications
- Docker-based Lambda layer building for cross-platform compatibility

## 🛠️ Technology Stack

- **Infrastructure as Code**: Terraform 1.x
- **Cloud Provider**: AWS
- **Programming Languages**: HCL (Terraform), Python 3.12, Bash
- **AWS Services**: S3, CloudFront, Lambda, IAM, CloudWatch
- **Libraries**: Pillow (Python image processing)
- **Containerization**: Docker (for Lambda layer building)

## � Prerequisites

Before running these labs, ensure you have the following configured:

### AWS CLI Configuration

1. **Install AWS CLI** (if not already installed):

   ```bash
   # macOS with Homebrew
   brew install awscli

   # Or download from: https://aws.amazon.com/cli/
   ```

2. **Configure AWS CLI** with your credentials:
   ```bash
   aws configure
   ```
   You'll be prompted to enter:
   - AWS Access Key ID
   - AWS Secret Access Key
   - Default region name (e.g., `us-east-1`)
   - Default output format (e.g., `json`)

### Required AWS Permissions

Your AWS user/role needs the following permissions to run all labs:

#### Minimum IAM Policy (AdministratorAccess recommended for learning):

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:*",
        "cloudfront:*",
        "iam:*",
        "lambda:*",
        "logs:*",
        "ec2:DescribeRegions"
      ],
      "Resource": "*"
    }
  ]
}
```

#### Service-Specific Permissions:

- **S3**: Full access for bucket creation, object management
- **CloudFront**: Distribution creation and management
- **IAM**: User/group creation, policy attachment (for Lab 2)
- **Lambda**: Function creation, layer management (for Lab 3)
- **CloudWatch Logs**: Log group creation and management

### Additional Requirements

- **Terraform 1.x**: Install from [terraform.io](https://www.terraform.io/downloads)
- **Docker** (for Lab 3): Required for building Lambda layers
- **AWS Account**: With appropriate permissions and billing enabled

### Environment Setup

```bash
# Verify installations
aws --version
terraform --version
docker --version

# Verify AWS configuration
aws sts get-caller-identity
```

## �🚀 Getting Started

Each lab is self-contained. Navigate to the desired lab directory and follow the deployment instructions in its README.md.

```bash
# Example for Static Website Hosting
cd 1_Host-Static-Website
terraform init
terraform plan
terraform apply
```

## 📊 Architecture Principles

- **Modular Design**: Each lab is self-contained with its own Terraform configuration
- **Security First**: Implements least-privilege access, encryption, and secure defaults
- **Scalability**: Uses serverless and managed services where possible
- **Monitoring**: Includes logging and basic observability
- **Automation**: Includes deployment scripts for consistent provisioning
