### Implementing Input variables ###
variable "region_value" {
  description = "Region for EC2 instance"
  type        = string
}

variable "ami_value" {
  description = "AMI ID for EC2 instance"
  type        = string
}

variable "instance_type_value" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "subnet_id_value" {
  description = "Subnet id for EC2 instance"
  type        = string
}

variable "key_name_value" {
  description = "Key-pair for EC2 instance"
  type        = string
}