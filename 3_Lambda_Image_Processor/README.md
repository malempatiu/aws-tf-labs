## 🏗️ Architecture Overview
This lab implements a fully serverless image processing pipeline using AWS Lambda, triggered by S3 events, demonstrating event-driven architecture.

<img width="1016" height="449" alt="Screenshot 2026-02-14 at 12 33 36" src="https://github.com/user-attachments/assets/b7cc1bf2-b03e-4b84-8708-c7cd6d02e4b6" />

### Components

#### **Storage Layer**

- **Upload Bucket**: S3 bucket for raw image uploads
- **Processed Bucket**: S3 bucket for processed image variants
- **Security**: Both buckets encrypted with SSE-S3 and public access blocked
- **Versioning**: Enabled for data protection and rollback capabilities

#### **Compute Layer**

- **Lambda Function**: Python 3.12 runtime with Pillow library for image processing
- **Lambda Layer**: Custom layer containing Pillow dependencies
- **Memory/Timeout**: 1024MB RAM, 60-second timeout for processing large images
- **Environment Variables**: Configurable processed bucket and log level

#### **Event Processing**

- **S3 Event Notifications**: Triggers Lambda on object creation (`s3:ObjectCreated:*`)
- **Lambda Permissions**: Grants S3 permission to invoke the function
- **CloudWatch Logs**: Centralized logging with 7-day retention

#### **Image Processing Pipeline**

The Lambda function performs:

1. **Format Conversion**: JPEG, PNG, WebP, BMP, TIFF support
2. **Compression**: Multiple quality levels (85%, 60%)
3. **Resizing**: Automatic downscaling for images >4096px
4. **Thumbnail Generation**: 300x300px thumbnails
5. **Variant Creation**: Multiple formats and sizes per input image

### Data Flow

```
Image Upload → S3 Upload Bucket → Event Notification → Lambda Function → Processing → S3 Processed Bucket
     ↓
Variants: compressed.jpg, low.jpg, webp.webp, png.png, thumbnail.jpg
```

### Security & Permissions

- **IAM Role**: Least-privilege policy for S3 read/write and CloudWatch logging
- **Encryption**: Server-side encryption on all buckets
- **Access Control**: Private buckets with no public access

### Deployment Automation

- **Docker-based Layer Building**: Cross-platform Lambda layer creation
- **Terraform Automation**: Complete infrastructure provisioning
- **Validation**: Terraform plan and validation before deployment

### Key Features

- Event-driven serverless processing
- Multiple image format support
- Automatic optimization and compression
- Thumbnail generation
- Comprehensive logging and error handling
- Automated deployment scripts

## 🚀 Deployment

1. Run the deployment script: `./scripts/deploy.sh`
2. Or manually:
   - Build the Lambda layer: `./scripts/build_layer_docker.sh`
   - Initialize Terraform: `cd terraform && terraform init`
   - Plan and apply: `terraform plan && terraform apply`

## 📁 Project Structure

```
3_Lambda_Image_Processor/
├── lambda/
│   ├── lambda_function.py    # Main Lambda handler
│   └── requirements.txt      # Python dependencies
├── terraform/
│   ├── main.tf              # Main Terraform configuration
│   ├── variables.tf         # Input variables
│   ├── outputs.tf           # Output values
│   ├── terraform.tfvars     # Variable values
│   ├── provider.tf          # AWS provider configuration
│   ├── backend.tf           # State backend configuration
│   └── pillow_layer.zip     # Built Lambda layer (generated)
├── scripts/
│   ├── deploy.sh            # Automated deployment script
│   ├── build_layer_docker.sh # Docker-based layer building
│   └── destroy.sh           # Cleanup script
└── README.md
```
