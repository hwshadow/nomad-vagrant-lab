# HashiCorp Nomad - Local Lab Using Vagrant

### Accompanying blog for the initial setup:  https://discoposse.com/2019/11/21/building-a-hashicorp-nomad-cluster-lab-using-vagrant-and-virtualbox/
### Pluralsight course - Getting Started with HashiCorp Nomad:  https://app.pluralsight.com/library/courses/hashicorp-nomad-getting-started/table-of-contents
### Hashipoc
https://github.com/pete0emerson/hashipoc
### other hashi nomady things
https://github.com/jippi/awesome-nomad

## What is this?

A simple 3-node or 6-node lab running Ubuntu servers on VirtualBox and each node runs Consul and Nomad servers which can be configured as a cluster.

## Why use this method?

This is a great way to get your feet wet with Nomad in a simplified environment and you also have a chance to mess around with the configurations and commands without risking a cloud (read: money) installation or a production (read: danger!) environment.

## Requirements

There are a few things you need to get this going:

* Vagrant (hashicorp)

* Packer (hashicorp)

* VirtualBox

## How to use the Nomad lab configuration


* Clone this repo (or fork it of you so desire and want to contribute to it)

* Change directory and run a `vagrant status` to check the dependencies are met

### Short road to victory road

* `./bootstrap.sh` to do all setup in one command.

Now you're running!
### Long road to victory road (because you like good ol' fashion work)

* Pack a base box `packer_build.sh` this makes it so that you don't have to apt-get install each host

* `./render_vagrantfile.sh` to select `Vagrantfile.6node` (sed away to fit your system)
```
if desired, you can manually `cp ./Vagrantfile.Nnode ./Vagrantfile`
For 3-node clusters you must rename `Vagrantfile.3node` to `Vagrantfile`
For 6-node (two region) clusters you must rename `Vagrantfile.6node` to `Vagrantfile`
```

* Run a `vagrant up` command and watch the magic happen! (spoiler alert: it's not magic, it's technology)
Each node will able to run Consul and Nomad (servers and clients)

To start your Nomad cluster just do this:

* `./cluster_up.sh`

Now you're running!

### Short road to victory road

* `./nuke.sh` will forcefully destroy your vagrant environment, and the packer image, running `./bootstrap.sh` after nuke will create a new enivornment from scratch (not using a cached vagrant base). You should use this command if you have editted the `node-install.sh` script.

## Link wan
To link the clusters
```
from 172.16.1.201 #nomad-b-1
nomad server join 172.16.1.101
consul join -wan 172.16.1.101
```

## Interacting with the Nomad and Consul cluster

Logging into the systems locally can be done

* You can use some simple commands to get started
```
nomad node status
```
* To open the Nomad UI use this command on your local machine
```
open http://172.16.1.101:4646
```
