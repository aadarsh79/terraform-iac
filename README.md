# HashiCorp Terraform - HCL

## Why Terraform ?

1. **Multi-Cloud Support**: Terraform is known for its multi-cloud support. It allows you to define infrastructure in a cloud-agnostic way, meaning you can use the same configuration code to provision resources on various cloud providers (AWS, Azure, Google Cloud, etc.) and even on-premises infrastructure. This flexibility can be beneficial if your organization uses multiple cloud providers or plans to migrate between them.
2. **Large Ecosystem**: Terraform has a vast ecosystem of providers and modules contributed by both HashiCorp (the company behind Terraform) and the community. This means you can find pre-built modules and configurations for a wide range of services and infrastructure components, saving you time and effort in writing custom configurations.
3. **Declarative Syntax**: Terraform uses a declarative syntax, allowing you to specify the desired end-state of your infrastructure. This makes it easier to understand and maintain your code compared to imperative scripting languages.
4. **State Management**: Terraform maintains a state file that tracks the current state of your infrastructure. This state file helps Terraform understand the differences between the desired and actual states of your infrastructure, enabling it to make informed decisions when you apply changes.
5. **Plan and Apply**: Terraform's "plan" and "apply" workflow allows you to preview changes before applying them. This helps prevent unexpected modifications to your infrastructure and provides an opportunity to review and approve changes before they are implemented.
6. **Integration with Other Tools**: Terraform can be integrated with other DevOps and automation tools, such as Docker, Kubernetes, Ansible, and Jenkins, allowing you to create comprehensive automation pipelines.
7. **HCL Language**: Terraform uses HashiCorp Configuration Language (HCL), which is designed specifically for defining infrastructure. It's human-readable and expressive, making it easier for both developers and operators to work with.

## Components in Terraform

1. **Provider**: A provider is a plugin for Terraform that defines and manages resources for a specific cloud or infrastructure platform. Examples of providers include AWS, Azure, Google Cloud, and many others. You configure providers in your Terraform code to interact with the desired infrastructure platform.
    
    ```hcl
    provider "aws" {
      region = "us-east-1"
    }
    ```
    
    **required_providers block:**
    
    ```hcl
    terraform {
      required_providers {
        aws = {
          source = "hashicorp/aws"
          version = "~> 3.79"
        }
      }
    }
    ```
    
2. **Resource**: A resource is a specific infrastructure component that you want to create and manage using Terraform. Resources can include virtual machines, databases, storage buckets, network components, and more. Each resource has a type and configuration parameters that you define in your Terraform code.
    
    ```hcl
    resource "aws_instance" "example" {
      ami = "ami-0123456789abcdef0" # Change the AMI instance_type = "t2.micro"
    }
    ```
    
    `azurerm` - for Azure
    
    `google` - for Google Cloud Platform
    
    `kubernetes` - for Kubernetes
    
    `openstack` - for OpenStack
    
    `vsphere` - for VMware vSphere
    
3. **Module**: A module is a reusable and encapsulated unit of Terraform code. Modules allow you to package infrastructure configurations, making it easier to maintain, share, and reuse them across different parts of your infrastructure. Modules can be your own creations or come from the Terraform Registry, which hosts community-contributed modules.
    
    
    ```hcl
    module "ec2_instance" {
      source = "./modules/ec2_instance"
    }
    ```
    
4. **Configuration File**: Terraform uses configuration files (often with a `.tf` extension) to define the desired infrastructure state. These files specify providers, resources, variables, and other settings. The primary configuration file is usually named `main.tf`, but you can use multiple configuration files as well.
5. **Variable**: Variables in Terraform are placeholders for values that can be passed into your configurations. They make your code more flexible and reusable by allowing you to define values outside of your code and pass them in when you apply the Terraform configuration.
6. **Output**: Outputs are values generated by Terraform after the infrastructure has been created or updated. Outputs are typically used to display information or provide values to other parts of your infrastructure stack.
7. **State File**: Terraform maintains a state file (often named `terraform.tfstate`) that keeps track of the current state of your infrastructure. This file is crucial for Terraform to understand what resources have been created and what changes need to be made during updates.
8. **Plan**: A Terraform plan is a preview of changes that Terraform will make to your infrastructure. When you run `terraform plan`, Terraform analyzes your configuration and current state, then generates a plan detailing what actions it will take during the `apply` step.
9. **Apply**: The `terraform apply` command is used to execute the changes specified in the plan. It creates, updates, or destroys resources based on the Terraform configuration.
10. **Workspace**: Workspaces in Terraform are a way to manage multiple environments (e.g., development, staging, production) with separate configurations and state files. Workspaces help keep infrastructure configurations isolated and organized.
11. **Remote Backend**: A remote backend is a storage location for your Terraform state files that is not stored locally. Popular choices for remote backends include Amazon S3, Azure Blob Storage, or HashiCorp Terraform Cloud. Remote backends enhance collaboration and provide better security and reliability for your state files.

## Installation on Linux (Ubuntu)

`wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg`

`echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] [https://apt.releases.hashicorp.com](https://apt.releases.hashicorp.com/) $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list`

`sudo apt update && sudo apt install terraform`

## Lifecycle of Terraform

terraform init —> terraform plan —> terraform apply —> terraform destroy

## Zeroday Tasks:

1. **Setup Terraform**: Configure AWS: Install AWS CLI and use command `aws configure` to configure AWS CLI on your host. Get required credentials from AWS console.
2. Clone this repository to apply IaC for AWS and create AWS Instances, s3 bucket for remote backend (where terraform.tfstate file gets stored for security purpose), DynamoDB to put the state-lock remotely.

    **Overcoming Disadvantages with Remote Backends (e.g., S3):**
A remote backend stores the Terraform state file outside of your local file system and version control. Using S3 as a remote backend is a popular choice due to its reliability and scalability. Here's how to set it up:
    
    1. **Create an S3 Bucket**: Create an S3 bucket in your AWS account to store the Terraform state. Ensure that the appropriate IAM permissions are set up.
    
    2. **Configure Remote Backend in Terraform:**
    
       ```hcl
       # In your Terraform configuration file (e.g., main.tf), define the remote backend.
       terraform {
         backend "s3" {
           bucket         = "your-bucket-name"
           key            = "terraform/terraform.tfstate"
           region         = "ap-south-1"
           encrypt        = true
           dynamodb_table = "your-dynamodb-table"
         }
       }
       ```

    **DynamoDB Table for State Locking:**
       To enable state locking, create a DynamoDB table and provide its name in the `dynamodb_table` field. This prevents concurrent access issues when multiple users or processes run Terraform.
    
    **State Locking with DynamoDB:**
    
    DynamoDB is used for state locking when a remote backend is configured. It ensures that only one user or process can modify the Terraform state at a time. Here's how to create a DynamoDB table and configure it for state locking:
    
    **Create a DynamoDB Table:**
       You can create a DynamoDB table using the AWS Management Console or AWS CLI. Here's an AWS CLI example:
    
       ```sh
       aws dynamodb create-table --table-name your-dynamodb-table --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5
       ```

## Flask App using EC2 with VPC:

**Used the concept of provisioners like**
1.  **'file' Provisioner**: The file provisioner is used to copy files or directories from the local machine to a remote machine. This is useful for deploying configuration files, scripts, or other assets to a provisioned instance.
    ```hcl
       provisioner "file" {
              source      = "local/path/to/localfile.txt"
              destination = "/path/on/remote/instance/file.txt"
              connection {
                type     = "ssh"
                user     = "ec2-user"
                private_key = file("~/.ssh/id_rsa")
              }
            }
    ```
2. **'remote-exec' Provisioner**: The remote-exec provisioner runs scripts or commands on a remote machine over SSH or WinRM connections. It's often used to configure or install software on provisioned instances.
   ```hcl
   provisioner "remote-exec" {
      inline = [
        "sudo yum update -y",
        "sudo yum install -y httpd",
        "sudo systemctl start httpd",
      ]
      connection {
        type        = "ssh"
        user        = "ec2-user"
        private_key = file("~/.ssh/id_rsa")
        host        = aws_instance.example.public_ip
      }
    }
   ```
3. **'local-exec' Provisioner**: The local-exec provisioner is used to run scripts or commands locally on the machine where Terraform is executed. It is useful for tasks that don't require remote execution, such as initializing a local database or configuring local resources.
   ```hcl
     provisioner "local-exec" {
        command = "echo 'This is a local command'"
      }
    }
   ```

## Terraform Workspaces

Terraform workspaces are a feature that allows you to manage multiple instances of a set of infrastructure within the same configuration. Each workspace has its own state data, which makes it possible to manage different environments (like development, staging, and production) from a single set of configuration files.

1. **Initialize Your Terraform Configuration**
  ```bash
  terraform init
  ```
2. **Create Workspaces**: Create workspaces for your environments. For example, to create a development and a production workspace, you can use the following commands:
  ```bash
  terraform workspace new dev
  terraform workspace new stage
  terraform workspace new prod
  ```
3. **Switch Between Workspaces**: You can switch between workspaces using the terraform workspace select command. When you're in a specific workspace, any terraform apply, terraform plan, or terraform destroy commands you run will only affect the state and resources associated with that workspace.
  ```bash
  terraform workspace select dev
  ```

4. **Use Variables to Differentiate Environments**: Terraform automatically manages separate state files for each workspace, ensuring that the state of your resources in one workspace doesn't interfere with those in another. This is particularly useful for maintaining different environments (dev, prod, etc.) within the same repository.
Here's an example of how your directory structure might look:
 .
  ├── main.tf
  ├── variables.tf
  ├── dev.tfvars
  └── stage.tfvars
  └── prod.tfvars

When applying the configuration, specify the appropriate .tfvars file:
  ```bash
  terraform apply -var-file=dev.tfvars --auto-approve
  terraform apply -var-file=prod.tfvars --auto-approve
  ```

Or, Modify main.tf to use different environment as per requirement.
  ```hcl
  variable "instance_type" {
    description = "value"
    type = map(string)

    default = {
      "dev" = "t2.micro"
      "stage" = "t2.medium"
      "prod" = "t2.xlarge"
    }
  }

  module "ec2_instance" {
    source = "./modules/ec2_instance"
    ami = var.ami
    instance_type = lookup(var.instance_type, terraform.workspace, "t2.micro")
  }
  ```

## Vault Integration

To install Vault on the EC2 instance, you can use the following steps:

**Install gpg**

```
sudo apt update && sudo apt install gpg
```

**Download the signing key to a new keyring**

```
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
```

**Verify the key's fingerprint**

```
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
```

**Add the HashiCorp repo**

```
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
```

```
sudo apt update
```

**Finally, Install Vault**

```
sudo apt install vault
```

## Start Vault.

To start Vault, you can use the following command:

```
vault server -dev -dev-listen-address="0.0.0.0:8200"
```

## Configure Terraform to read the secret from Vault.

Detailed steps to enable and configure AppRole authentication in HashiCorp Vault:

1. **Enable AppRole Authentication**:

To enable the AppRole authentication method in Vault, you need to use the Vault CLI or the Vault HTTP API.

**Using Vault CLI**:

Run the following command to enable the AppRole authentication method:

```bash
vault auth enable approle
```

This command tells Vault to enable the AppRole authentication method.

2. **Create an AppRole**:

We need to create policy first,

```
vault policy write terraform - <<EOF
path "*" {
  capabilities = ["list", "read"]
}

path "secrets/data/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "kv/data/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}


path "secret/data/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "auth/token/create" {
capabilities = ["create", "read", "update", "list"]
}
EOF
```

Now you'll need to create an AppRole with appropriate policies and configure its authentication settings. Here are the steps to create an AppRole:

**a. Create the AppRole**:

```bash
vault write auth/approle/role/terraform \
    secret_id_ttl=10m \
    token_num_uses=10 \
    token_ttl=20m \
    token_max_ttl=30m \
    secret_id_num_uses=40 \
    token_policies=terraform
```

3. **Generate Role ID and Secret ID**:

After creating the AppRole, you need to generate a Role ID and Secret ID pair. The Role ID is a static identifier, while the Secret ID is a dynamic credential.

**a. Generate Role ID**:

You can retrieve the Role ID using the Vault CLI:

```bash
vault read auth/approle/role/terraform/role-id
```

Save the Role ID for use in your Terraform configuration.

**b. Generate Secret ID**:

To generate a Secret ID, you can use the following command:

```bash
vault write -f auth/approle/role/terraform/secret-id
   ```

This command generates a Secret ID and provides it in the response. Save the Secret ID securely, as it will be used for Terraform authentication.

## Importing existing infra to Terraform

It can be performed using following steps:
1. **Using import block**: Create main.tf file and use import block to import already existing EC2 state to Terraform.
   ```hcl
   provider "aws" {
      region = "ap-south-1"
   }
   
   resource "aws_instance" "my_instance" {
   }
   
   import {
       id = "i-1234567890abcdef0"
       to = "aws_instance.my_instance"
   }
   ```
   Now, run this command to generate resources mentioned in main.tf in generated_ec2.tf by Terraform itself, so that this content can be copied to empty resource block of main.tf.
   ```bash
   terraform plan -generate-config-out=generated_ec2.tf
   ```
   But, the problem is when we do terraform plan, it is going to create already existing ec2 instance because the terraform does not know the state of this resource. For this, we need to create terraform.tfstate file using command
   ```bash
   terraform import aws_instance.my_instance i-1234567890abcdef0
   ```
   Now, if we do terraform plan, then it will not create new resource, it will say 'No changes'
   
   
