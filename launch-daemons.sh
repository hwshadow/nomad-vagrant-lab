#!/bin/bash
dc_letter_code=$(hostname | awk '{print $2}')
config_region=$(echo $dc_letter_code | sed 's/^a$/east/g;s/^b$/west/g')

cd $HOME

# Form Consul Cluster
ps -C consul
retval=$?
if [ $retval -eq 0 ]; then
  sudo killall consul
fi
sudo cp /vagrant/consul-config/consul-server-east.hcl /etc/consul.d/consul-server-$config_region.hcl
sudo nohup consul agent --config-file /etc/consul.d/consul-server-$config_region.hcl &>$HOME/consul.log &

# Form Nomad Cluster
ps -C nomad
retval=$?
if [ $retval -eq 0 ]; then
  sudo killall nomad
fi
sudo cp /vagrant/nomad-config/nomad-server-east.hcl /etc/nomad.d/nomad-server-$config_region.hcl
sudo nohup nomad agent -config /etc/nomad.d/nomad-server-$config_region.hcl &>$HOME/nomad.log &

ps -C consul
ps -C nomad
