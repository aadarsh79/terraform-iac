### Implementing Output variables ###
output "public_ip" {
    description = "Public IP of EC2 instance."
    value = aws_instance.demo-tf-ins.public_ip
}