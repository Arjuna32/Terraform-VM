#! /bin/bash
sudo apt-get update -y
sudo apt-get install openjdk-11-jre-headless -y
sudo apt-get install pythonpy -y
sudo apt-get install scala -y
sudo apt-get install nodejs npm -y
sudo apt-get install postgresql postgresql-contrib -y
sudo systemctl start postgresql.service 
#============= START spark===============
sudo apt-get install git -y
wget https://dlcdn.apache.org/spark/spark-3.2.1/spark-3.2.1-bin-hadoop3.2.tgz
tar xvf spark-*
sudo mv spark-3.2.1-bin-hadoop3.2 /opt/spark
rm spark-3.2.1-bin-hadoop3.2.tgz
echo "export SPARK_HOME=/opt/spark" >> ~/.profile
echo "export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin" >> ~/.profile
echo "export PYSPARK_PYTHON=/usr/bin/python3" >> ~/.profile
#============= END spark===============

#==============START jupyter =======================
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

#conda 
sudo curl https://repo.anaconda.com/pkgs/misc/gpgkeys/anaconda.asc | gpg --dearmor > conda.gpg
sudo install -o root -g root -m 644 conda.gpg /etc/apt/trusted.gpg.d/
echo "deb [arch=amd64] https://repo.anaconda.com/pkgs/misc/debrepo/conda stable main" | sudo tee /etc/apt/sources.list.d/conda.list
sudo apt-get install conda -y 
sudo ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh
sudo mkdir /opt/conda/envs/
sudo /opt/conda/bin/conda create --prefix /opt/conda/envs/python python=3.7 ipykernel
sudo /opt/conda/envs/python/bin/python -m ipykernel install --prefix=/opt/jupyterhub/ --name 'python' --display-name "Python (default)"
/path/to/kernel/env/bin/python -m ipykernel install --user --name 'python-my-env' --display-name "Python My Env"

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

sudo apt-get install apache2 -y
sudo systemctl start apache2
sudo systemctl enable apache2
echo "<h1>Azure Virtual Machine deployed with Terraform by Amaan Usmani</h1>" | sudo tee /var/www/html/index.html

