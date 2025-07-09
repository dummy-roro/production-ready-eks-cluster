module "irsa_s3" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name             = "irsa-s3-access"
  attach_policy_json    = true
  policy_json           = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = ["s3:GetObject", "s3:ListBucket"]
      Resource = "*"
    }]
  })
  oidc_providers = {
    eks = {
      provider_arn = module.eks.oidc_provider_arn
      namespace    = "default"
      service_account = "s3-reader"
    }
  }
}
