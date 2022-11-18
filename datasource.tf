# NTTDATA - DIGITAL ARCHITECTURE
# Create: Marcos Cianci


### AWS VPC ###
data "aws_vpc" "vpc-lab-eks" {
  tags = {Name = "vpc-lab-eks"}
}

### AWS Subnet Private and AWS Subnet Public ###
data "aws_subnet" "subnet-private-lab-1" {
  filter {
    name = "tag:name"
    values = ["subnet-private-lab-1"]
  }
}

data "aws_subnet" "subnet-private-lab-2" {
  filter {
    name = "tag:name"
    values = ["subnet-private-lab-2"]
  }
}

data "aws_subnet" "subnet-public-lab-1" {
  filter {
    name = "tag:name"
    values = ["subnet-public-lab-1"]
  }
}

data "aws_subnet" "subnet-public-lab-2" {
  filter {
    name = "tag:name"
    values = ["subnet-public-lab-2"]
  }
}



### AWS AMI ###
data "aws_ami" "ubuntu" {

    most_recent = true
    filter {
      name = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-focal-*.*-amd64-server-*"]
    }

    owners = ["099720109477"]
}

### AWS UserData ###
data "template_file" "user_data_bastionhost" {

    template = file("./scripts/userdata-bastionhost.sh")
}