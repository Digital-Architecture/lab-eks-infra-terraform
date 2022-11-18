# NTTDATA - DIGITAL ARCHITECTURE
# Create: Marcos Cianci 


### AWS EC2 - Bastion Host ###
module "ec2_bastion_host" {

    source                      = "git::https://github.com/Digital-Architecture/terraform-modules-aws-ec2.git"

    ec2_name                    = "bastion-host-eks-${terraform.workspace}"
    iam_instance_profile        = data.aws_ami.ubuntu
    ami                         = data.aws_ami.ubuntu.id
    monitoring                  = true
    vpc_security_group_id       = [""]
    subnet_id                   = data.aws_subnet.subnet-public-lab-1.id
    associate_public_ip_address = true

    user_data                   = data.tamplate_file.user_data_bastionhost.rendered

    root_block_device = [
        {
            encrypted   = true
            volume_type = "gp3"
            volume_size = "30"
            tags        = {
                Name = "bastionhost-root-block"
            }
        }
    ]

    tags                    = var.tags

}


### AWS IAM ###


### AWS Security Group ###
