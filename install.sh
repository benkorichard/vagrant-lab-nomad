#!/bin/bash

sudo apt -y update
sudo apt -y install unzip curl vim jq

sudo apt remove docker docker-engine docker.io
curl https://get.docker.com | sh
sudo usermod -aG docker vagrant

NOMAD_VERSION=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/nomad | jq -r ".current_version")
cd /tmp/install

[[ ! -d /etc/nomad.d ]] && { sudo mkdir -p /etc/nomad.d; sudo cp /tmp/install/nomad.hcl /etc/nomad.d/; }

sudo curl -sSL https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip -o nomad.zip
[[ ! -d nomad ]] && sudo unzip nomad.zip

[[ ! -f /usr/bin/nomad ]] && sudo install nomad /usr/bin/nomad

CONSUL_VERSION=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/consul | jq -r ".current_version")

[[ ! -d /etc/consul.d ]] && { sudo mkdir -p /etc/consul.d; sudo cp /tmp/install/consul.hcl /etc/consul.d/; }

sudo curl -sSL https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip > consul.zip
[[ ! -d consul ]] && sudo unzip /tmp/install/consul.zip

[[ ! -f /usr/bin/consul ]] && sudo install consul /usr/bin/consul

for bin in cfssl cfssl-certinfo cfssljson
do
  echo "$bin Install Beginning..."
  [[ ! -f /tmp/install/${bin} ]] && curl -sSL https://pkg.cfssl.org/R1.2/${bin}_linux-amd64 > /tmp/install/${bin}

  [[ ! -f /usr/local/bin/${bin} ]] && sudo install /tmp/install/${bin} /usr/local/bin/${bin}
done
cat /root/.bashrc | grep  "complete -C /usr/bin/nomad nomad"
ret=$?

[[ $ret -eq 1 ]] && nomad -autocomplete-install

sudo cp /tmp/install/*.service /etc/systemd/system/
sudo systemctl enable consul
sudo systemctl enable nomad
sudo systemctl start nomad

rm -rf /tmp/install