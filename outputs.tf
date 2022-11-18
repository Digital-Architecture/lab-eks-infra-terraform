# NTTDATA - DIGITAL ARCHITECTURE
# Create: Marcos Cianci 


output "security_group_id" {

    description = ""
    value = module.sg_bastion_host.security_group_id
  
}
