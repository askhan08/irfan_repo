#!/bin/bash

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
sudo sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/' /etc/mongod.conf
sudo systemctl start mongod
sudo systemctl enable mongod
