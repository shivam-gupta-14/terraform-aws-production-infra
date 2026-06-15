terraform {
  backend "s3" {
    bucket         = "shivam-terraform-state-2026"
    key            = "prod/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}