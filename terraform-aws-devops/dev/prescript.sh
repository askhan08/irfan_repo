#!/bin/bash

##mongo installaiton
cd /etc/yum.repos.d
cat <<EOF | sudo tee /etc/yum.repos.d/mongo.repo
[mongodb-org-3.6]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/7/mongodb-org/3.6/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-3.6.asc
EOF

sudo yum -y install  mongodb-org
#sudo sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/' /etc/mongod.conf
sudo systemctl start mongod
sudo systemctl enable mongod
###########
#!/bin/bash
sudo yum -y install git maven
cd /opt
sudo git clone https://github.com/learnk8s/knote-java.git
sudo amazon-linux-extras install java-openjdk11 -y
sudo unlink /etc/alternatives/java
sudo ln -s /usr/lib/jvm/java-11-openjdk-11.0.16.0.8-1.amzn2.0.1.x86_64/bin/java /etc/alternatives/java
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-11.0.16.0.8-1.amzn2.0.1.x86_64
dburl=`aws ssm get-parameter --name dburi --region us-east-1 --query Parameter.Value | sed 's/"//g'` && sudo sed -i "s/localhost/$dburl/" /opt/knote-java/01/src/main/resources/application.properties
cd /opt/knote-java/01 && mvn clean install
sudo groupadd -r appmgr
sudo useradd -r -s /bin/false -g appmgr jvmapps
cat <<EOF | sudo tee /etc/systemd/system/knoteapp.service
[Unit]
Description=Manage Java service

[Service]
WorkingDirectory=/opt/knote-java/01/target
ExecStart=/bin/java -jar knote-java-1.0.0.jar
User=jvmapps
Type=simple
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF
chown -R jvmapps:appmgr /opt/knote-java/01/target
sudo systemctl daemon-reload
sudo systemctl enable knoteapp.service
sudo systemctl start knoteapp.service

