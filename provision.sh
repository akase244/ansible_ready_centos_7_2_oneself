#!/bin/bash

# install epel
sudo rpm --import http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-6.noarch.rpm
sudo yum localinstall -y epel-release-7-6.noarch.rpm

# install sshpass(noninteractive ssh password provider)
sudo yum install -y sshpass

# create .ssh directory
if [[ ! -f ~/.ssh ]]; then
  mkdir -p ~/.ssh
fi

# generate rsa key
if [[ ! -f ~/.ssh/id_rsa ]]; then
  ssh-keygen -t rsa -q -f ~/.ssh/id_rsa -P ""
fi

# copy rsa key
cat ~/.ssh/id_rsa.pub | sshpass -p "vagrant" ssh -o StrictHostKeyChecking=no vagrant@192.168.34.1 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"

# install python-simplejson (required for ansible)
sudo yum install -y python-simplejson

# install ansible
sudo yum install -y ansible

# configure host for ansible
cat <<EOF > hosts
[provision_serv]
192.168.34.1
EOF

# test connect
ansible -i hosts provision_serv -m ping
