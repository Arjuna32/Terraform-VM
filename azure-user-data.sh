#! /bin/bash
sudo apt-get update -y
sudo apt-get install openjdk-11-jre-headless -y
sudo apt-get install pythonpy -y
sudo apt-get install scala -y
sudo apt-get install nodejs npm -y
sudo apt-get install postgresql postgresql-contrib -y
sudo systemctl start postgresql.service 

echo "============= START spark==============="
#following https://phoenixnap.com/kb/install-spark-on-ubuntu
sudo apt-get install git -y
wget https://dlcdn.apache.org/spark/spark-3.3.0/spark-3.3.0-bin-hadoop3.tgz
tar xvf spark-*
sudo mv spark-3.3.0-bin-hadoop3 /opt/spark
rm spark-3.3.0-bin-hadoop3.tgz
echo "export SPARK_HOME=/opt/spark" >> ~/.profile
echo "export PATH=\$PATH:\$SPARK_HOME/bin:\$SPARK_HOME/sbin" >> ~/.profile
echo "export PYSPARK_PYTHON=/usr/bin/python3" >> ~/.profile
export SPARK_HOME=/opt/spark
export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
export PYSPARK_PYTHON=/usr/bin/python3
sudo mkdir /opt/spark/logs
sudo chmod 777 /opt/spark/logs
start-master.sh
sudo mkdir /opt/spark/work
sudo chmod 777 /opt/spark/work
#start one slave server on port 7077

#url must match computer_name

echo "============= END spark==============="

#==============START jupyter =======================
#wget https://repo.anaconda.com/miniconda/Miniconda3-py39_4.12.0-Linux-x86_64.sh
#sudo bash Miniconda3-latest-Linux-x86_64.sh

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
#following https://github.com/jupyterhub/jupyterhub-the-hard-way/blob/HEAD/docs/installation-guide-hard.md
sudo echo "c.Spawner.default_url = '/lab'" >> /opt/jupyterhub/etc/jupyterhub/jupyterhub_config.py
sudo mkdir -p /opt/jupyterhub/etc/systemd
sudo echo "[Unit]">> /opt/jupyterhub/etc/systemd/jupyterhub.service
sudo echo "Description=JupyterHub">> /opt/jupyterhub/etc/systemd/jupyterhub.service
sudo echo "After=syslog.target network.target">> /opt/jupyterhub/etc/systemd/jupyterhub.service
sudo echo " ">> /opt/jupyterhub/etc/systemd/jupyterhub.service
sudo echo "[Service]">> /opt/jupyterhub/etc/systemd/jupyterhub.service
sudo echo "User=root">> /opt/jupyterhub/etc/systemd/jupyterhub.service
sudo echo "Environment=\"PATH=/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/opt/jupyterhub/bin\"">> /opt/jupyterhub/etc/systemd/jupyterhub.service
sudo echo "ExecStart=/opt/jupyterhub/bin/jupyterhub -f /opt/jupyterhub/etc/jupyterhub/jupyterhub_config.py">> /opt/jupyterhub/etc/systemd/jupyterhub.service
sudo echo "">> /opt/jupyterhub/etc/systemd/jupyterhub.service
sudo echo "[Install]">> /opt/jupyterhub/etc/systemd/jupyterhub.service
sudo echo "WantedBy=multi-user.target">> /opt/jupyterhub/etc/systemd/jupyterhub.service

sudo ln -s /opt/jupyterhub/etc/systemd/jupyterhub.service /etc/systemd/system/jupyterhub.service
sudo systemctl daemon-reload
sudo systemctl enable jupyterhub.service
sudo systemctl start jupyterhub.service
sudo systemctl status jupyterhub.service

#miniconda
echo "===================MINICONDA START================="
sudo mkdir -p /opt/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /opt/miniconda3/miniconda.sh
sudo bash /opt/miniconda3/miniconda.sh -b -u -p /opt/miniconda3
sudo rm -rf /opt/miniconda3/miniconda.sh
sudo /opt/miniconda3/bin/conda init bash
sudo /opt/miniconda3/bin/conda init zsh

sudo ln -s /opt/miniconda3/etc/profile.d/conda.sh /etc/profile.d/conda.sh
sudo /opt/miniconda3/bin/conda create --prefix /opt/miniconda3/envs/python python=3.7 ipykernel -y
sudo /opt/miniconda3/envs/python/bin/python -m ipykernel install --prefix=/opt/jupyterhub/ --name 'python' --display-name "Python (default)"
sudo /opt/miniconda3/envs/python/bin/python -m ipykernel install --prefix /usr/local/ --name 'python' --display-name "Python (default)"


echo "===================MINICONDA DONE================="
#reverse proxy
sudo apt-get install nginx -y
sudo echo "c.JupyterHub.bind_url = 'http://:8000/jupyter'" >> /opt/jupyterhub/etc/jupyterhub/jupyterhub_config.py
sudo echo  "map \$http_upgrade \$connection_upgrade {
        default upgrade;
        '' close;
    }" | cat - /etc/nginx/sites-available/default | grep -v "^}" > /tmp/default.tmp
sudo mv /tmp/default.tmp /etc/nginx/sites-available/default
sudo echo "  location /jupyter/ {
    # NOTE important to also set base url of jupyterhub to /jupyter in its config
    proxy_pass http://127.0.0.1:8000;

    proxy_redirect   off; 
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header Host \$host;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto \$scheme;

    # websocket headers
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection \$connection_upgrade;

  }
}" >> /etc/nginx/sites-available/default
  
  #restart nginx
sudo systemctl restart nginx.service
#==============END jupyter =======================
echo "starting spark worker"
vmname=`hostname`
start-slave.sh spark://$vmname:7077
echo "============================== TF_VAR_vm_name=<$TF_VAR_vm_name>"

echo "creating a test user"
echo testuser1:password2001::::/home/testuser1:/bin/bash | sudo newusers
sudo usermode -aG sudo testuser1

