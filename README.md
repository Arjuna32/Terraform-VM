# <center>READ ME
# one time setup: 
* Follow the instructions on one of the websites to install terraform
  * [How to install terraform in Windows with Bash](https://docs.microsoft.com/en-us/azure/developer/terraform/get-started-windows-bash?tabs=bash)
  * [How to install terraform in Windows with Powershell](https://docs.microsoft.com/en-us/azure/developer/terraform/get-started-windows-powershell?tabs=bash)
  * Change the following variables in `providers.tf` to your azure account and principal
    * `subscription_id`
    * `tenant_id`
    * `client_id`
    * `client_secret`
    
# <center>How to run this terraform vm code

1. make sure the command prompt is in the directory where the files are stored
   * use cd <*folder name*>
2. Initialize terraform by running `terraform init`
3. Run `terraform plan -out main.tfplan` to create an execution plan
4. Run `terraform apply main.tfplan` to apply and create the vm in the cloud

# <center>How to Log in to the newly created vm

1. Run `terraform output -raw tls_private_key > id_rsa` to create your SSH private key and save it to id_rsa
2. Run `terraform output public_ip_address` to get the ip address of the vm
3. Run `ssh -i id_rsa azureuser@<public_ip_address>` using the actual ip address obtained in the previous step
4. you should now be logged in to the virtual machine

# Destroyinh the full environment including the vm 
* if need be you can use `terraform destroy` to destroy the full environment and the vm
