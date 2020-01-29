#!/bin/bash
if [ ! -f "./Vagrantfile" ]; then
  echo 'hacking the gibson'
  cat ./Vagrantfile.6node | sed 's/vb.memory = "1516"/vb.memory = "1024"/g' > ./Vagrantfile
fi
