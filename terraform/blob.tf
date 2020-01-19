# Storage account & Blob
resource "azurerm_storage_account" "tfblob" {
  name                     = "${var.prefix}blobacct"
  resource_group_name      = azurerm_resource_group.tfrg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  tags = {
    environment = var.tag
  }
}

resource "azurerm_storage_container" "tfblob" {
  name                  = "blob"
  storage_account_name  = azurerm_storage_account.tfblob.name
  container_access_type = "blob"
}

resource "azurerm_storage_blob" "tfblob_iisscript" {
  name = "iis_script.ps1"

  storage_account_name   = azurerm_storage_account.tfblob.name
  storage_container_name = azurerm_storage_container.tfblob.name

  type   = "block"
  source = "./blob/iis_script.ps1"

  depends_on = [local_file.appsettings]
}

resource "azurerm_storage_blob" "tfblob_appsettings" {
  name = "appsettings.json"

  storage_account_name   = azurerm_storage_account.tfblob.name
  storage_container_name = azurerm_storage_container.tfblob.name

  type   = "block"
  source = "./blob/appsettings.json"

  depends_on = [local_file.appsettings]
}

resource "local_file" "appsettings" {
  content     = templatefile("./blob/appsettings.tpl", { kvname = "${var.prefix}kv"})
  filename = "./blob/appsettings.json"
}