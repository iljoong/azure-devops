module "agt" {
    source    = "./agt"
    rgname    = azurerm_resource_group.tfrg.name
    location  = var.location
    tag       = var.tag

    prefix         = var.prefix
    admin_username = var.admin_username
    admin_password = var.admin_password
    vm_size        = "Standard_D4s_v3"
    
    subnet_id       = azurerm_subnet.tfagtvnet.id
}

output "ip" {
    value = "${module.agt.agentvm_ip}"
}