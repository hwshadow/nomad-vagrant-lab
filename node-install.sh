#!/bin/bash
dc_letter_code=$(hostname | awk -F'-' '{print $2}')
config_region=$(echo $dc_letter_code | sed 's/^a$/east/g;s/^b$/west/g')

# Update the apt packages and get a couple of basic tools
sudo apt-get update -y
sudo apt-get install unzip curl vim jq -y
# make an archive folder to move old binaries into
if [ ! -d /tmp/archive ]; then
  sudo mkdir /tmp/archive/
fi

# Install Docker Community Edition
echo "Docker Install Beginning..."
sudo apt-get remove docker docker-engine docker.io
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg |  sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) \
      stable"
sudo apt-get update -y
sudo apt-get install -y docker-ce
#"cluster-store":"consul://127.0.0.1:8500",
sudo echo '{ "bip":"192.168.125.1/24", "default-address-pools":[{"base":"172.31.0.0/16","size":25},{"base":"192.168.0.0/20","size":26}]}' > /etc/docker/daemon.json
sudo service docker restart
# Configure Docker to be run as the vagrant user
sudo usermod -aG docker vagrant
sudo docker --version

echo "Nomad Install Beginning..."
# For now we use a static version. Set to the latest tested version you want here.
NOMAD_VERSION=0.9.5
cd /tmp/
sudo curl -sSL https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip -o nomad.zip
if [ ! -d nomad ]; then
  sudo unzip nomad.zip
fi
if [ ! -f /usr/bin/nomad ]; then
  sudo install nomad /usr/bin/nomad
fi
if [ -f /tmp/archive/nomad ]; then
  sudo rm /tmp/archive/nomad
fi
sudo mv /tmp/nomad /tmp/archive/nomad
sudo mkdir -p /etc/nomad.d
sudo chmod a+w /etc/nomad.d
#sudo cp -r /vagrant/nomad-config/nomad-server-$config_region.hcl /etc/nomad.d/nomad-server-$config_region.hcl

echo "Consul Install Beginning..."
# Uncommend the first and comment the second line to get the latest edition
# Otherwise use the static number
CONSUL_VERSION=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/consul | jq -r ".current_version")
#CONSUL_VERSION=1.4.0
sudo curl -sSL https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip > consul.zip
if [ ! -d consul ]; then
  sudo unzip /tmp/consul.zip
fi
if [ ! -f /usr/bin/consul ]; then
  sudo install consul /usr/bin/consul
fi
if [ -f /tmp/archive/consul ]; then
  sudo rm /tmp/archive/consul
fi
sudo mv /tmp/consul /tmp/archive/consul
sudo mkdir -p /etc/consul.d
sudo chmod a+w /etc/consul.d
#sudo cp -r /vagrant/consul-config/consul-server-$config_region.hcl /etc/consul.d/consul-server-$config_region.hcl

echo "Consul-template Install Beginning..."
sudo curl -sSL https://releases.hashicorp.com/consul-template/0.24.1/consul-template_0.24.1_linux_amd64.zip > consul-tmpl.zip
if [ ! -d consul-tmpl ]; then
  sudo unzip /tmp/consul-tmpl.zip
fi
if [ ! -f /usr/bin/consul-template ]; then
  sudo install consul-template /usr/bin/consul-template
fi

for bin in cfssl cfssl-certinfo cfssljson
do
  echo "$bin Install Beginning..."
  if [ ! -f /tmp/${bin} ]; then
    curl -sSL https://pkg.cfssl.org/R1.2/${bin}_linux-amd64 > /tmp/${bin}
  fi
  if [ ! -f /usr/local/bin/${bin} ]; then
    sudo install /tmp/${bin} /usr/local/bin/${bin}
  fi
done
cat /root/.bashrc | grep  "complete -C /usr/bin/nomad nomad"
retval=$?
if [ $retval -eq 1 ]; then
  nomad -autocomplete-install
fi
