# NTTDATA - DIGITAL ARCHITECTURE
# Create: Marcos Cianci 


### AWS IAM ###
module "role-bastionhost-ec2" {

    source              = "git::https://github.com/Digital-Architecture/terraform-modules-aws-iam.git//roles"

    name_role           = "role-bastionhost-${terraform.workspace}-ec2"
    json_role           = file("./files/iam/role-ec2.json")
}

module "instance-profile-bastionhost" {

    source                  = "git::https://github.com/Digital-Architecture/terraform-modules-aws-iam.git//iam_instance_profile"

    name_instance_profile   = "instance-profile-${terraform.workspace}-bastionhost-ec2"
    role_id                 = module.role-bastionhost-ec2.role-id

}

### AWS Security Group ###
module "sg_bastion_host" {

    source                  = "git::https://github.com/Digital-Architecture/terraform-modules-aws-security-group.git"

    name_security_group     = "scg-ec2-bastion-host-${terraform.workspace}"
    vpc_id                  = data.aws_vpc.vpc-lab-eks.id
    tags                    = var.tags

    sg_rules = [
        {
            type            = "ingress"
            from_port       = 22
            to_port         = 22
            protocol        = "tcp"
            cidr_blocks     = "0.0.0.0/0"
            description     = "Allow SSH"
        },
        {
            type            = "egress"
            from_port       = 0
            to_port         = 0
            protocol        = "-1"
            cidr_blocks     = "0.0.0.0/0"
            description     = "Allow Traffic Outbound"
        }
    ]
}


### AWS EC2 - Bastion Host ###
module "ec2_bastion_host" {

    source                      = "git::https://github.com/Digital-Architecture/terraform-modules-aws-ec2.git"

    ec2_name                    = "bastion-host-eks-${terraform.workspace}"
    iam_instance_profile        = ""
    ami                         = data.aws_ami.ubuntu.id
    instance_type               = "t3.small"
    monitoring                  = true
    vpc_security_group_ids      = ["module.sg_bastion_host.security_group_id"]
    subnet_id                   = data.aws_subnet.subnet-public-lab-1.id 
    associate_public_ip_address = true

    user_data                   = data.template_file.user_data_bastionhost.rendered

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

    tags                = var.tags

    depends_on = [module.sg_bastion_host]
}





