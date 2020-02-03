#!/bin/bash
set -e

vagrant box add bento/ubuntu-16.04 --provider virtualbox || true
#https://ketzacoatl.github.io/posts/2017-06-01-use-existing-vagrant-box-in-a-packer-build.html
#ls -Alh ~/.vagrant.d/boxes/bento-VAGRANTSLASH-ubuntu-16.04/201912.15.0/virtualbox/
#~/.vagrant.d/boxes/$REPO-VAGRANTSLASH-$BOX/$VERSION/$VM_PROVIDER/box.ovf
packer build ./packer_template.json || true
vagrant box add nomad-base-host output-box/base-host-bento-ubuntu-16.04-201912.15.0.box || true
