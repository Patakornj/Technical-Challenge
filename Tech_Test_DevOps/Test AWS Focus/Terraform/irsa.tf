data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_name
}

data "tls_certificate" "eks_oidc" {
  url = module.eks.cluster_oidc_issuer_url
}

data "aws_iam_openid_connect_provider" "eks_oidc" {
  url = module.eks.cluster_oidc_issuer_url
}

# IRSA Role
resource "aws_iam_role" "irsa_role" {

  name = "irsa-s3-access"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = data.aws_iam_openid_connect_provider.eks_oidc.arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${module.eks.cluster_oidc_issuer_url}/sub" = "system:serviceaccount:default:irsa-s3-sa"
        }
      }
    }]
  })
}

# Create s3 policy
resource "aws_iam_policy" "s3_policy" {
  name        = "irsa-s3-policy"
  description = "Allows IRSA service account to access S3"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow"
      Action   = ["s3:GetObject", "s3:ListBucket"]
      Resource = ["arn:aws:s3:::your-s3-bucket-name", "arn:aws:s3:::your-s3-bucket-name/*"]
    }]
  })
}

# Attach IAM policy to the role
resource "aws_iam_role_policy_attachment" "attach_s3" {
  policy_arn = aws_iam_policy.s3_policy.arn
  role       = aws_iam_role.irsa_role.name
}


resource "kubectl_manifest" "irsa_sa" {
  yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  name: irsa-s3-sa
  namespace: default
  annotations:
    eks.amazonaws.com/role-arn: ${aws_iam_role.irsa_role.arn}
YAML
}