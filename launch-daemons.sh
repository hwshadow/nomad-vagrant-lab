#!/bin/bash
dc_letter_code=$(hostname | awk -F'-' '{print $2}')
config_region=$(echo $dc_letter_code | sed 's/^a$/east/g;s/^b$/west/g')

cd $HOME

# JIEdits dnsmasq
sudo cp /vagrant/dnsmasq-config/dnsmasq.conf /etc/dnsmasq.conf
sudo cp /vagrant/dnsmasq-config/dnsmasq.consul /etc/dnsmasq.d/10-consul
sudo service dnsmasq restart

# JIEdits docker
sudo cp /vagrant/docker-config/daemon.conf /etc/docker/daemon.conf
sudo service docker restart

# Form Consul Cluster
ps -C consul
retval=$?
if [ $retval -eq 0 ]; then
  sudo killall consul
fi
sudo cp /vagrant/consul-config/consul-server-$config_region.hcl /etc/consul.d/consul-server-$config_region.hcl
sudo nohup consul agent --config-file /etc/consul.d/consul-server-$config_region.hcl &>$HOME/consul.log &

# Form Nomad Cluster
ps -C nomad
retval=$?
if [ $retval -eq 0 ]; then
  sudo killall nomad
fi
sudo cp /vagrant/nomad-config/nomad-server-$config_region.hcl /etc/nomad.d/nomad-server-$config_region.hcl
sudo nohup nomad agent -config /etc/nomad.d/nomad-server-$config_region.hcl &>$HOME/nomad.log &

ps -C consul
ps -C nomad
