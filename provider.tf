terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket         = "<your-s3-bucket-name>"
    key            = "eks-cluster/terraform.tfstate"
    region         = var.aws_region
    dynamodb_table = "<your-lock-table-name>"
    encrypt        = true
  }
}
