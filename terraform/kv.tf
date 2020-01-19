resource "azurerm_key_vault" "tfrg" {
  name                        = "${var.prefix}kv"
  location                    = azurerm_resource_group.tfrg.location
  resource_group_name         = azurerm_resource_group.tfrg.name
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id

  sku_name = "standard"

  enabled_for_deployment          = true
  enabled_for_template_deployment = true

  # user assigned identity
  access_policy {
    tenant_id = var.tenant_id
    object_id = azurerm_user_assigned_identity.tfrg.principal_id

    key_permissions = [
        "get"
    ]
    
    secret_permissions = [
        "get",
        "list",
        "set",
        "delete",
        "recover",
        "backup",
        "restore"
    ]
    
    certificate_permissions = [
        "get",
        "list",
        "update",
        "create",
        "import",
        "delete",
        "recover",
        "backup",
        "restore"
    ]
  }

  /*
  # user access: manually add it
  access_policy {
    tenant_id = var.tenant_id
    object_id = var.user_object_id

    key_permissions = [
        "get"
    ]

    secret_permissions = [
        "get",
        "list",
        "set",
        "delete",
        "recover",
        "backup",
        "restore"
    ]
    
    certificate_permissions = [
        "get",
        "list",
        "update",
        "create",
        "import",
        "delete",
        "recover",
        "backup",
        "restore"
    ]
  }
  */
  
  tags = {
    environment = var.tag
  }
}

