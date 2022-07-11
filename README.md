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

1. make sure your git bash is in the directory where the files are stored
   * use cd <*folder name*>
2. run ./start.sh to automatically start the creation process.
  - the script is going to ask you to name the following variables, however it will show the default values in []: 
    - vm name
    - image publisher
    - image offer 
    - image SKU
    - image version
  - to use the default variables, press enter when prompted
   

# <center>How to Log in to the newly created vm

1. Run `ssh -i id_rsa azureuser@<public_ip_address>` using the actual ip address obtained in the previous step
2. you should now be logged in to the virtual machine
3. the vm is going to come with a running Spark master and worker servers, the URL for the master server is http://<public ip address>:8080
 
 
# Destroying the full environment including the vm 
* if need be you can run ./stop.sh which will permanently terminate your vm
