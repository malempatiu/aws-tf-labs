## 🏗️ Architecture Overview

This lab implements a secure, globally distributed static website using AWS's Content Delivery Network (CDN) architecture.

<img width="1027" height="416" alt="Screenshot 2026-02-01 at 19 12 01" src="https://github.com/user-attachments/assets/11ed912d-a75a-445c-919b-6b92e9c0197e" />


### Components

#### **Storage Layer**
- **S3 Bucket**: Serves as the origin for static website files (HTML, CSS, JavaScript)
- **Security**: Completely private with public access blocked via `aws_s3_bucket_public_access_block`
- **Content Management**: Automated upload of website files using `aws_s3_object` with proper MIME types

#### **Content Delivery Layer**
- **CloudFront Distribution**: Global CDN for low-latency content delivery
- **Origin Access Control (OAC)**: Secure access to S3 bucket without public policies
- **HTTPS Enforcement**: Automatic redirect to HTTPS
- **Caching Strategy**: Optimized cache behaviors for static assets

#### **Security Architecture**
- **No Public Access**: S3 bucket is private; all access through CloudFront
- **Bucket Policy**: Grants CloudFront service principal read-only access to objects
- **Signed Requests**: Uses SigV4 signing for S3 origin access

### Data Flow
```
User Request → CloudFront Edge Location → CloudFront Origin (S3) → Static Files
```

### Key Features
- Global content delivery with edge caching
- Automatic HTTPS redirection
- Secure S3 origin with OAC
- Support for multiple file types with correct content types

## 🚀 Deployment

1. Update `terraform.tfvars` with your desired bucket name
2. Run `terraform init`
3. Run `terraform plan`
4. Run `terraform apply`
5. Access your website via the CloudFront distribution URL

## 📁 Project Structure

```
1_Host-Static-Website/
├── main.tf              # Main Terraform configuration
├── variables.tf         # Input variables
├── outputs.tf           # Output values
├── terraform.tfvars     # Variable values
├── provider.tf          # AWS provider configuration
├── backend.tf           # State backend configuration
├── website/             # Static website files
│   ├── index.html
│   ├── style.css
│   └── script.js
└── README.md
```
