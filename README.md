# DevOps Technical Interview Test (AWS Focused)

## Objective:
Build a fully automated infrastructure and deployment pipeline using Terraform, Argo CD for GitOps, and GitHub Actions for CI/CD. 

## Prerequisites

- `IAM user`: with the necessary permissions to work with Terraform in AWS. The IAM user should have the following policies attached:

```
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Action": [
				"ec2:*",
				"eks:*",
				"s3:*",
				"rds:*",
				"iam:*",
				"sts:*",
				"logs:*",
				"ecr:*",
				"kms:*"
			],
			"Resource": "*"
		}
	]
}
```

- `Argo CD`: (https://argoproj.github.io/argo-cd/) installed and configured.
- `Amazon ECR`: (https://aws.amazon.com/ecr/) repository for storing Docker images.
- `GitHub Actions`: (https://github.com/features/actions) enabled for the repository.
- `Google Chat`: (https://chat.google.com/) webhook URL for posting CI/CD pipeline results.

## Secrets

The following secrets need to be configured in the GitHub repository:

- `AWS_ACCESS_KEY_IDS`: AWS access key ID.
- `AWS_SECRET_ACCESS_KEY`: AWS secret access key.
- `AWS_REGION`: AWS region.
- `AWS_ECR_URI`: URI of the Amazon ECR repository.
- `GITHUB_EMAIL`: Email for Git configuration.
- `GITHUB_USERNAME`: Username for Git configuration.
- `ARGOCD_SERVER`: URL of the Argo CD server.
- `ARGOCD_USERNAME`: Username for Argo CD authentication.
- `ARGOCD_PASSWORD`: Password for Argo CD authentication.
- `GOOGLE_CHAT_WEBHOOK_URL`: Webhook URL for Google Chat.

## Terraform

- `eks.tf`: Defines the configuration for the Amazon EKS cluster using the terraform-aws-modules/eks/aws module.
- `vpc.tf`: Configures the VPC, subnets, and VPC endpoints required for the EKS cluster.
- `variables.tf`: Defines the input variables used in the Terraform configuration.
- `s3.tf`: Provisions an S3 bucket for storing application data or artifacts.
- `rds.tf`: Provisions an RDS instance for the database needs of the application.
- `providers.tf`: Configures the AWS and Kubernetes providers for Terraform.
- `irsa.tf`: Configures IAM roles and policies for IRSA to allow Kubernetes service accounts to access AWS resources.

## Argo CD

- `backend.yaml`: Argo CD Application manifest for the backend application.
- `frontend.yaml`: Argo CD Application manifest for the frontend application.
- `backend-deployment.yaml`: Kubernetes deployment manifest for the backend application.
- `frontend-deployment.yaml`: Kubernetes deployment manifest for the frontend application

## CI/CD Pipeline

The CI/CD pipeline is defined in the ci-cd-pipeline.yml file. It performs the following steps:

- `Checkout`: Checks out the repository.
- `Set up AWS credentials`: Configures AWS credentials for accessing Amazon ECR.
- `Run Trivy SAST scan`: Runs a security scan using Trivy.
- `Build Docker image`: Builds the Docker image for the application.
- `Log in to Amazon ECR`: Logs in to Amazon ECR.
- `Push Docker image to ECR`: Pushes the Docker image to Amazon ECR.
- `Update Kubernetes deployment manifest for frontend`: Updates the image in the frontend deployment manifest.
- `Update Kubernetes deployment manifest for backend`: Updates the image in the backend deployment manifest.
- `Commit updated manifest files`: Commits and pushes the updated manifest files to the repository.
- `Trigger Argo CD sync`: Triggers Argo CD to sync the frontend and backend applications.
- `Post results to Google Chat`: Posts the CI/CD pipeline results to a Google Chat channel.
