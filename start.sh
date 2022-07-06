#!/bin/bash
terraform init 

#set VM name
read -p "Enter the name for your Virtual Machine [Test_VM]" TF_VAR_vm_name
TF_VAR_vm_name=${TF_VAR_vm_name:-Test_VM}
echo $TF_VAR_vm_name

read -p "Enter the name for your image publisher [Canonical]" TF_VAR_image_publisher
TF_VAR_image_publisher=${TF_VAR_image_publisher:-Canonical}
echo $TF_VAR_image_publisher

read -p "Enter the name for your image offer [UbuntuServer]" TF_VAR_image_offer
TF_VAR_image_offer=${TF_VAR_image_offer:-UbuntuServer}
echo $TF_VAR_image_offer

read -p "Enter the name for your image SKU [18.04-LTS]" TF_VAR_image_sku
TF_VAR_image_sku=${TF_VAR_image_sku:-18.04-LTS}
echo $TF_VAR_image_sku

read -p "Enter the name for your image version [latest]" TF_VAR_image_version
TF_VAR_image_version=${TF_VAR_image_version:-latest}
echo $TF_VAR_image_version


terraform plan -out main.tfplan
terraform apply main.tfplan
terraform output -raw tls_private_key > id_rsa

vmip=`terraform output public_ip_address`
echo "vmip is ${vmip//\"}"
echo "Use this command to connect to the vm: ssh -i id_rsa azureuser@${vmip//\"}"
