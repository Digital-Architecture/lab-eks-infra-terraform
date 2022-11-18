# NTTDATA - DIGITAL ARCHITECTURE
# Create: Marcos Cianci 

terraform {
  backend "s3" {
      bucket    = "terraform-labs-digital-architecture"
      key       = "terraform/lab-eks-infra.tfstate"
      region    = "us-west-1"
  }
}