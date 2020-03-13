#!/bin/bash
if [ ! -f "./Vagrantfile" ]; then
  echo 'hacking the gibson'
  cat ./Vagrantfile.3node | sed 's/vb.memory = "1516"/vb.memory = "2048"/g' > ./Vagrantfile
fi
