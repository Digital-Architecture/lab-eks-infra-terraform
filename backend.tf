# NTTDATA - DIGITAL ARCHITECTURE
# Create: Marcos Cianci 

terraform {

  required_version = ">=0.14"

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.15.0"
    }
    
     random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.4.0"
    }

     cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.2.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.12.1"
    }

  }
  
  backend "s3" {
      bucket    = "terraform-labs-digital-architecture"
      key       = "terraform/lab-eks-infra.tfstate"
      region    = "us-west-1"
  }
}