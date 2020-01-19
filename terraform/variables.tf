# azure service principal info
variable "subscription_id" {
  default = "add_here"
}

# client_id or app_id
variable "client_id" {
  default = "add_here"
}

variable "client_secret" {
  default = "add_here"
}

# tenant_id or directory_id
variable "tenant_id" {
  default = "add_here"
}

# admin password
variable "admin_username" {
  default = "azureuser"
}

variable "admin_password" {
  default = "add_here"
}

# service variables
variable "prefix" {
  default = "tfdemo"
}

variable "location" {
  default = "koreacentral"
}

variable "vmsize" {
  default = "Standard_D4s_v3"
}

variable "tag" {
  default = "devopsdemo"
}

/*
variable "osimageuri" {
  default = "add_here"
}

variable "webcount" {
  default = 1
}

variable "appcount" {
  default = 1
}

variable "certificate_path" {
  default = "add_here"
}

variable "certificate_password" {
    default = "add_here"
}

variable "user_object_id" {
    default = "add_here"
}

variable "user_msi_name" {
    default = "add_here"
}

variable "user_msi_rg" {
    default = "add_here"
}

variable "tf_object_id" {
    default = "add_here"
}
*/

