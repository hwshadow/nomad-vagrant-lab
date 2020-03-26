data_dir = "/tmp/nomad/server"

server {
  enabled          = true
  bootstrap_expect = 3
  job_gc_threshold = "2m"
}

datacenter = "toronto"

region = "east"

advertise {
  http = "{{ GetInterfaceIP `eth1` }}"
  rpc  = "{{ GetInterfaceIP `eth1` }}"
  serf = "{{ GetInterfaceIP `eth1` }}"
}

host_volume "elasticsearch" {
  path      = "/opt/nomad/volumes/elasticsearch/"
  read_only = false
}

host_volume "generic1" {
  path      = "/opt/nomad/volumes/generic1/"
  read_only = false
}
host_volume "generic2" {
  path      = "/opt/nomad/volumes/generic2/"
  read_only = false
}
host_volume "generic3" {
  path      = "/opt/nomad/volumes/generic3/"
  read_only = false
}
host_volume "generic4" {
  path      = "/opt/nomad/volumes/generic4/"
  read_only = false
}
host_volume "generic5" {
  path      = "/opt/nomad/volumes/generic5/"
  read_only = false
}

plugin "raw_exec" {
  config {
    enabled = true
  }
}

client {
  enabled           = true
  network_interface = "eth1"
  servers           = ["172.16.1.101", "172.16.1.102", "172.16.1.103"]
}
