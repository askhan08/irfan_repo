#terraform {
#  backend "s3" {
#    bucket         = "terraform-state-bucket-myorg"
#    key            = "terraform.tfstate"
#    region         = "us-east-1"
#    dynamodb_table = "terraform_state"
#  }
#}