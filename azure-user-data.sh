#! /bin/bash
sudo apt-get update -y
sudo apt-get install openjdk-11-jre-headless -y
sudo apt-get install pythonpy -y
sudo apt-get install scala -y
sudo apt-get update -y
sudo apt-get install nodejs npm -y
sudo apt-get install postgresql postgresql-contrib -y
sudo systemctl start postgresql.service 
#for spark
sudo apt-get install git -y
wget https://dlcdn.apache.org/spark/spark-3.2.1/spark-3.2.1-bin-hadoop3.2.tgz
tar xvf spark-*
sudo mv spark-3.2.1-bin-hadoop3.2 /opt/spark
rm spark-3.2.1-bin-hadoop3.2.tgz
echo "export SPARK_HOME=/opt/spark" >> ~/.profile
echo "export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin" >> ~/.profile
echo "export PYSPARK_PYTHON=/usr/bin/python3" >> ~/.profile

#==============for jupyter
sudo apt-get install python3-venv -y
sudo python3 -m venv /opt/jupyterhub/
#upgrade nodejs to latest 
sudo curl -sL https://deb.nodesource.com/setup_17.x -o /tmp/nodesource_setup.sh
sudo bash /tmp/nodesource_setup.sh
sudo apt-get install nodejs -y
# install jupyterhub and jupyterlab
sudo /opt/jupyterhub/bin/python3 -m pip install wheel 
sudo  /opt/jupyterhub/bin/python3 -m pip install --upgrade pip
sudo /opt/jupyterhub/bin/python3 -m pip install jupyterhub jupyterlab
sudo /opt/jupyterhub/bin/python3 -m pip install ipywidgets
sudo npm install -g configurable-http-proxy 
sudo mkdir -p /opt/jupyterhub/etc/jupyterhub/
cd /opt/jupyterhub/etc/jupyterhub/
sudo /opt/jupyterhub/bin/jupyterhub --generate-config
#this one isn't working right now, https://github.com/jupyterhub/jupyterhub-the-hard-way/blob/HEAD/docs/installation-guide-hard.md
sudo echo "c.Spawner.default_url = '/lab'" >> /opt/jupyterhub/etc/jupyterhub/jupyterhub_config.py


sudo apt-get install apache2 -y
sudo systemctl start apache2
sudo systemctl enable apache2
echo "<h1>Azure Virtual Machine deployed with Terraform by Amaan Usmani</h1>" | sudo tee /var/www/html/index.html

