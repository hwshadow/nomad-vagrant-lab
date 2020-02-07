#!/bin/bash
./packer_build.sh
./render_vagrantfile.sh
vagrant up
./cluster_up.sh
