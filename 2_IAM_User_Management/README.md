## 🏗️ Architecture Overview

This lab demonstrates enterprise-grade identity and access management using AWS IAM, with automated user provisioning from CSV data.

<img width="930" height="505" alt="Screenshot 2026-02-05 at 21 02 23" src="https://github.com/user-attachments/assets/8b751626-7106-4edb-bc13-473d896ce1ea" />

### Components

#### **Data Source Layer**
- **CSV Input**: User data stored in `users.csv` with fields: first_name, last_name, department, job_title
- **Local Processing**: Terraform locals parse CSV and create user mappings

#### **Identity Management**
- **IAM Users**: Automated creation with naming convention `{first_name}-{last_name}`
- **IAM Groups**: Department-based groups (Development, DevOps, etc.)
- **Group Memberships**: Automatic assignment based on user department
- **Login Profiles**: Password-based authentication with reset requirements

#### **Access Control**
- **Policy Attachments**:
  - Operations group: `AdministratorAccess`
  - Other groups: `ReadOnlyAccess`
- **Tagging**: Users tagged with department and job title for organization

### User Provisioning Flow
```
CSV Data → Terraform Locals → IAM Users → Group Assignment → Policy Attachment
```

### Key Features
- Bulk user creation from CSV
- Department-based access control
- Automated group memberships
- Secure password management with reset requirements
- Comprehensive user tagging for organization

## 🚀 Deployment

1. Update `users.csv` with your user data
2. Update `terraform.tfvars` with your desired user groups
3. Run `terraform init`
4. Run `terraform plan`
5. Run `terraform apply`
6. Retrieve user passwords from Terraform outputs

## 📁 Project Structure

```
2_IAM_User_Management/
├── main.tf              # Main Terraform configuration
├── groups.tf            # IAM groups configuration
├── local.tf             # Local variables and data processing
├── variables.tf         # Input variables
├── outputs.tf           # Output values
├── terraform.tfvars     # Variable values
├── provider.tf          # AWS provider configuration
├── backend.tf           # State backend configuration
├── users.csv            # User data source
└── README.md
```
