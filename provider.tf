terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket         = "terraform-state-eks-cluster"
    key            = "eks-cluster/terraform.tfstate"
    region         = "us-east-1"                          # Replace with your actual region
    dynamodb_table = "terraform-state-dynamodb-table"
    encrypt        = true
  }
}
