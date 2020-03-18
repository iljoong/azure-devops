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

variable "rgname" {
  default = "_add_here_"
}

variable "vm_size" {
  default = "Standard_D4s_v3"
}

variable "subnet_id" {
  default = "_add_here_"
}

variable "tag" {
  default = "_add_here_"
}