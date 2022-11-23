# NTTDATA - DIGITAL ARCHITECTURE
# Create: Marcos Cianci 


### AWS IAM ###
module "role-bastionhost-ec2" {

    source              = "git::https://github.com/Digital-Architecture/terraform-modules-aws-iam.git//roles"

    name_role           = "role-bastionhost-${var.environment}-ec2"
    json_role           = file("./files/iam/role-ec2.json")
}

module "instance-profile-bastionhost" {

    source                  = "git::https://github.com/Digital-Architecture/terraform-modules-aws-iam.git//iam_instance_profile"

    name_instance_profile   = "instance-profile-${var.environment}-bastionhost-ec2"
    role_id                 = module.role-bastionhost-ec2.role-id

}

### AWS Security Group ###
module "sg_bastion_host" {

    source                  = "git::https://github.com/Digital-Architecture/terraform-modules-aws-security-group.git"

    name_security_group     = "scg-ec2-bastion-host-${var.environment}"
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

    ec2_name                    = "bastion-host-eks-${var.environment}"
    iam_instance_profile        = ""
    ami                         = data.aws_ami.ubuntu.id
    instance_type               = "t3.small"
    monitoring                  = true
    security_groups             = [ module.sg_bastion_host.security_group_id ]
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


## AWS EKS ###
module "eks-lab" {

    source                          = "terraform-aws-modules/eks/aws"
    version                         = "18.26.6"
    
    cluster_name                    = local.cluster_name
    cluster_version                 = "1.22"

    vpc_id                          = data.aws_vpc.vpc-lab-eks.id
    subnet_ids                     = [data.aws_subnet.subnet-private-lab-1.id, data.aws_subnet.subnet-private-lab-2.id ,data.aws_subnet.subnet-public-lab-1.id, data.aws_subnet.subnet-public-lab-2.id]

    eks_managed_node_group_defaults = {
        ami_type = "AL2_x86_64"

        attach_cluster_primary_security_group = true

        # Disabling and using externally provided security groups
        create_security_group = false
    }

    eks_managed_node_groups = {
      one = {
        name = "node-group-1"

        instance_types = ["t3.small"]

        min_size     = 1
        max_size     = 3
        desired_size = 2

        pre_bootstrap_user_data = <<-EOT
        echo 'foo bar'
        EOT

        vpc_security_group_ids = [
          module.sg_eks_node_group_one
        ]
      }

      two = {
        name = "node-group-2"

        instance_types = ["t3.medium"]

        min_size     = 1
        max_size     = 2
        desired_size = 1

        pre_bootstrap_user_data = <<-EOT
        echo 'foo bar'
        EOT

        vpc_security_group_ids = [
          module.sg_eks_node_group_two
        ]
      }
}

}


module "sg_eks_node_group_one" {

    source                  = "git::https://github.com/Digital-Architecture/terraform-modules-aws-security-group.git"

    name_security_group     = "scg-eks-node-group-one-${var.environment}"
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


module "sg_eks_node_group_two" {

    source                  = "git::https://github.com/Digital-Architecture/terraform-modules-aws-security-group.git"

    name_security_group     = "scg-eks-node-group-two-${var.environment}"
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
