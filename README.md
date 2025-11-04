# MongoDB Atlas Terraform Infrastructure

Production-grade infrastructure as code for deploying MongoDB Atlas clusters with secure network connectivity and user management across multiple environments.

## Overview

This Terraform configuration provisions a complete MongoDB Atlas infrastructure with:

- Multi-environment deployment (development, staging, production)
- AWS PrivateLink connectivity for secure network access
- VPC infrastructure with public, private, database, and elasticache subnets
- Advanced MongoDB Atlas clusters with environment-specific configurations
- Team-based access control with role-based permissions
- Database user management with automated credential generation

## Architecture

### Network Architecture

- AWS VPC with multi-tier subnet architecture across 3 availability zones
- MongoDB Atlas network containers for each environment
- AWS PrivateLink endpoints for secure, private connectivity
- NAT gateway for outbound internet access from private subnets

### MongoDB Atlas Resources

- Dedicated projects per environment (development, staging, production)
- Advanced clusters with M10/M20 instance sizes
- Network containers with isolated CIDR blocks
- PrivateLink endpoints for each environment

### Access Control

- Team-based organization with developer, tester, and devops roles
- Environment-specific user assignments
- Project-level and team-level permissions
- Automated user-to-team and user-to-project assignments

## Prerequisites

### Required Tools

- Terraform >= 1.13.0
- AWS CLI configured with appropriate credentials
- MongoDB Atlas account with organization-level access
- MongoDB Atlas API key (public and private)

### Required Permissions

**AWS:**
- EC2 full access (VPC, subnets, endpoints, security groups)
- IAM permissions for service-linked roles

**MongoDB Atlas:**
- Organization Owner or Project Owner role
- API key with organization read/write permissions

## Configuration

### 1. MongoDB Atlas API Credentials

Set the following environment variables:

```bash
export MONGODB_ATLAS_PUBLIC_KEY="your_public_key"
export MONGODB_ATLAS_PRIVATE_KEY="your_private_key"
```

Or create a `.env` file (see `.env.example`):

```bash
MONGODB_ATLAS_PUBLIC_KEY=your_public_key
MONGODB_ATLAS_PRIVATE_KEY=your_private_key
```

### 2. AWS Credentials

Configure AWS credentials using one of the following methods:

```bash
export AWS_ACCESS_KEY_ID="your_access_key"
export AWS_SECRET_ACCESS_KEY="your_secret_key"
export AWS_DEFAULT_REGION="ap-south-1"
```

Or use AWS CLI profiles:

```bash
aws configure --profile terraform
export AWS_PROFILE=terraform
```

### 3. Customize Local Variables

Edit `locals.tf` to match your organization:

```terraform
locals {
  org_short_name = "myorg"                    # Your organization name
  org_id         = "your_aws_org_id"          # AWS Organization ID
  region         = "ap-south-1"               # AWS region
  mongo_org_id   = "your_mongodb_atlas_org_id" # MongoDB Atlas Org ID
  
  vpc_cidr              = "10.10.0.0/16"
  secondary_cidr_blocks = ["10.11.0.0/21", "10.12.0.0/21"]
}
```

### 4. Configure User Assignments

Edit `mongodbatlas_user_assignment.tf` to define users and their roles:

```terraform
locals {
  users = {
    developer = [
      "dev1@example.com",
      "dev2@example.com"
    ]
    tester = [
      "tester1@example.com"
    ]
    devops = [
      "admin@example.com"
    ]
  }
}
```

### 5. Configure Database User Labels

**IMPORTANT:** Before deploying, update the database user labels in `mongodbatlas_database_user.tf`. Replace the placeholder format strings `"%s"` with actual values:

```terraform
labels {
  key   = "environment"
  value = "development"  # or "staging", "production"
}
```

This step is required for each database user resource (development, staging, production).

## Deployment

### Initial Setup

1. Clone the repository:
```bash
git clone <repository_url>
cd mongoatlas_terraform
```

2. Initialize Terraform:
```bash
terraform init
```

3. Review the execution plan:
```bash
terraform plan
```

4. Deploy all resources:
```bash
terraform apply
```

Terraform will automatically handle resource dependencies and create everything in the correct order.

## Resource Details

### Projects

Three MongoDB Atlas projects are created:
- `{org_short_name}-project-development`
- `{org_short_name}-project-staging`
- `{org_short_name}-project-production`

### Clusters

**Development:**
- Instance Size: M10
- Nodes: 3 (replicaset)
- Backup: Disabled
- Auto-scaling: Disabled
- **Cost Optimization:** Currently configured with M10. Consider upgrading to M20 or higher for production workloads.

**Staging:**
- Instance Size: M10
- Nodes: 3 (replicaset)
- Backup: Disabled
- Auto-scaling: Disabled
- **Recommendation:** Enable backups for staging to mirror production environment for testing disaster recovery procedures.

**Production:**
- Instance Size: M10
- Nodes: 3 (replicaset)
- Backup: Enabled
- Auto-scaling: Enabled (compute: M10-M20, disk enabled)
- **Recommendation:** Upgrade to M20 or higher for better production performance and redundancy.

### Network Configuration

**VPC Subnets:**
- Private subnets: Primary application tier
- Public subnets: NAT gateway, bastion hosts
- Database subnets: RDS and other databases
- Elasticache subnets: Redis/Memcached
- Intra subnets: Internal services

**MongoDB Atlas Network Containers:**
- Development: 192.168.248.0/21
- Staging: 192.168.248.0/21
- Production: 192.168.248.0/21

> **Note:** All environments use the same CIDR block (192.168.248.0/21). This is intentional as each environment has its own isolated network container.

### Teams and Roles

**Teams:**
- Developer teams per environment
- Tester teams per environment
- DevOps teams per environment

**Role Permissions:**
- Developer: `GROUP_DATA_ACCESS_ADMIN`
- Tester: `GROUP_DATA_ACCESS_READ_WRITE`
- DevOps: `GROUP_OWNER`
- Readonly: `GROUP_DATA_ACCESS_READ_ONLY`

## Outputs

The following outputs are available after deployment:

```bash
terraform output
```

Key outputs include:
- VPC ID and CIDR blocks
- Subnet IDs for each tier
- MongoDB Atlas project IDs
- Cluster connection strings
- PrivateLink endpoint service names
- Database user credentials (sensitive)

## Maintenance

### Adding Users

1. Edit `mongodbatlas_user_assignment.tf`
2. Add user email to appropriate role array
3. Apply changes:
```bash
terraform apply
```

### Scaling Clusters

Edit cluster configurations in `mongodbatlas_advanced_cluster.tf`:

```terraform
electable_specs = {
  instance_size = "M30"  # Scale up
  node_count    = 5      # Add nodes
}
```

Then apply:
```bash
terraform apply
```

### Updating Network Configuration

Modify CIDR blocks in `locals.tf` and network resources in `mongodbatlas_network.tf`. Note that some network changes may require resource recreation.

## Security Considerations

### Secrets Management

- Never commit `.env` files or `terraform.tfvars` with secrets
- Use environment variables or secret management services (AWS Secrets Manager, HashiCorp Vault)
- Database passwords are randomly generated and stored in Terraform state

### Network Security

- PrivateLink ensures traffic never traverses the public internet
- Security groups restrict access to VPC endpoints
- MongoDB Atlas IP allowlists are managed separately

### Access Control

- Principle of least privilege for team assignments
- Environment-specific permissions
- Regular audit of user access

## Troubleshooting

### PrivateLink Connection Issues

If VPC endpoint creation fails:

1. Verify service names exist in AWS:
```bash
aws ec2 describe-vpc-endpoint-services \
  --service-names <service_name> \
  --region ap-south-1
```

2. Check MongoDB Atlas endpoint status:
```bash
atlas privateEndpoints aws list --projectId <project_id>
```

3. Ensure regions match between VPC and Atlas endpoints

### State Inconsistencies

If Terraform state becomes inconsistent:

```bash
terraform refresh
terraform plan
```

For severe issues, consider targeted resource replacement:
```bash
terraform taint <resource_address>
terraform apply
```

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

**Warning:** This will delete all MongoDB Atlas clusters and data. Ensure backups are in place.

For selective destruction:
```bash
terraform destroy -target=<resource_address>
```

## File Structure

```
.
├── README.md                                    # This file
├── .gitignore                                   # Git ignore patterns
├── .env.example                                 # Environment variable template
├── version.tf                                   # Provider versions
├── locals.tf                                    # Local variables
├── vpc.tf                                       # AWS VPC and endpoints
├── mongodbatlas_project.tf                      # Atlas projects
├── mongodbatlas_network.tf                      # Atlas network containers
├── mongodbatlas_private_endpoints_service.tf    # PrivateLink service connections
├── mongodbatlas_advanced_cluster.tf             # MongoDB clusters
├── mongodbatlas_database_user.tf                # Database users
├── mongodbatlas_teams.tf                        # Team definitions
└── mongodbatlas_user_assignment.tf              # User access control
```

## Contributing

1. Create a feature branch
2. Make changes and test locally
3. Run `terraform fmt` to format code
4. Run `terraform validate` to check syntax
5. Submit pull request with detailed description

## Support

For issues related to:
- **Terraform configuration:** Open an issue in this repository
- **MongoDB Atlas:** Contact MongoDB Atlas support
- **AWS resources:** Consult AWS documentation or support

## Authors

**Authored by [Blue-Samarth](https://github.com/blue-samarth)**

## Version History

- **v1.0.0** - Initial release with multi-environment support