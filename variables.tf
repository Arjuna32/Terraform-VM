variable "resource_group_name_prefix" {
  default       = "terraformRG"
  description   = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "resource_group_location" {
  default       = "centralus"
  description   = "Location of the resource group."
}

variable "vm_size" {
  default       = "Standard_B2S"
  description   = "size of the vm"
}

variable "vm_name" {
  default       = "MyVM"
  description   = "Name of the virtual machine"
}
variable "private_vm_name" {
  default       = "MyPrivateVM"
  description   = "Name of the virtual machine"
}

variable "image_publisher" {
  default       = "Canonical"
  description   = "Name of the image publisher"
}
variable "image_offer" {
  default       = "UbuntuServer"
  description   = "Name of the Image offer"
}
variable "image_sku" {
  default       = "18.04-LTS"
  description   = "Image sku"
}

variable "image_version" {
  default       = "latest"
  description   = "image version"
}
variable "admin_username" {
  default       = "azureuser1"
  description   = "private vm username"
}
variable "admin_password" {
  default       = "TestPassword1^"
  description   = "private vm password"
}
variable "private_computer_name" {
  default       = "MyPrivateComputerVM"
  description   = "private vm computer name"
}