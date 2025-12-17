terraform {
  backend "s3" {
    bucket         = "terraform-state-file-maintenance"
    key            = "ec2/terraform.tfstate"
    region         = "eu-north-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}