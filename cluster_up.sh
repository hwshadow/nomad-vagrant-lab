#!/bin/bash
nomad_nodes=$(vagrant ssh-config 2>/dev/null | grep -E '(Host|Port|IdentityFile) ' | xargs -L 3)
for i in {1..3}; do
  for dc in "a" "b"; do
    suffix="${dc}-${i}"
    nomad_node_line=$(printf '%s\n' $nomad_nodes | xargs -L 6 | grep "nomad-$suffix" | tr '\n' ' ')
    #echo $nomad_node_line
    if [ -z "$nomad_node_line" ]
    then
      echo -e ":( nomad-$suffix unavaliable, skipping\n"
      continue;
    fi
    port=$(echo $nomad_node_line | grep -Eo 'Port \S+' | awk '{print $2}')
    ident=$(echo $nomad_node_line | grep -Eo 'IdentityFile \S+' | awk '{print $2}')
    echo ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p $port -i $ident vagrant@localhost
    # NOOP
    #ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p $port -i $ident vagrant@localhost -t 'cd /vagrant && ls -l | grep launch-daemons.sh' 2>/dev/null

    # TEARDOWN
    ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p $port -i $ident vagrant@localhost -t 'sudo killall consul; sudo killall nomad; sudo rm -rf /tmp/nomad/server; sudo rm -rf /tmp/consul/server' 2>/dev/null
    echo ''
  done;
done;

for i in {1..3}; do
  for dc in "a" "b"; do
    suffix="${dc}-${i}"
    nomad_node_line=$(printf '%s\n' $nomad_nodes | xargs -L 6 | grep "nomad-$suffix" | tr '\n' ' ')
    #echo $nomad_node_line
    if [ -z "$nomad_node_line" ]
    then
      echo -e ":( nomad-$suffix unavaliable, skipping\n"
      continue;
    fi
    port=$(echo $nomad_node_line | grep -Eo 'Port \S+' | awk '{print $2}')
    ident=$(echo $nomad_node_line | grep -Eo 'IdentityFile \S+' | awk '{print $2}')
    echo ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p $port -i $ident vagrant@localhost
    # MANUAL SETUP
    #ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p $port -i $ident vagrant@localhost
    #cd /vagrant/; sudo ./launch-daemons.sh; exit

    # UPSTART
    ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p $port -i $ident vagrant@localhost -t 'cd /vagrant; sudo ./launch-daemons.sh' 2>/dev/null
    echo ''
  done;
  echo '# sleeping 5'; sleep 5; echo ''
done;
