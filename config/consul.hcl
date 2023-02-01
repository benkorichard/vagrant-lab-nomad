data_dir = "/tmp/consul/server"

server           = true
bootstrap_expect = 3
advertise_addr   = "{{ GetInterfaceIP `eth1` }}"
client_addr      = "0.0.0.0"
ui               = true
datacenter       = "main"
retry_join       = [
  "192.168.100.101",
  "192.168.100.102",
  "192.168.100.103"
]