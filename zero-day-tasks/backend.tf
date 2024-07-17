terraform {
  backend "s3" {
    bucket = "adarsh-mishra-s3"
    region = "ap-south-1"
    key = "terraform/terraform.tfstate"
    encrypt        = true
    # kms_key_id = ""
    dynamodb_table = "terraform-lock"
  }
}