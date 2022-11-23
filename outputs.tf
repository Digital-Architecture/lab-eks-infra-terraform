# NTTDATA - DIGITAL ARCHITECTURE
# Create: Marcos Cianci 


output "security_group_id" {

    description = ""
    value = module.sg_bastion_host.security_group_id
}


output "sg_nodegroup_one_id" {

    description = ""
    value = module.sg_eks_node_group_one.security_group_id
}

output "sg_nodegroup_two_id" {

    description = ""
    value = module.sg_eks_node_group_two.security_group_id
}
