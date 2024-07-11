provider "aws" {
  region = "ap-south-1"
}

module "aws_ec2_instance" {
  source = "./modules/aws_ec2_instance"
  region_value = "ap-south-1"
  ami_value = "ami-0ad21ae1d0696ad58"
  instance_type_value = "t2.micro"
  subnet_id_value = "subnet-0a48a9ab86ffa157f"
  key_name_value = "admin-ec2-key"
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "adarsh-mishra-s3"
}

resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
