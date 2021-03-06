#!/bin/sh

CONSUL_BIN_DIR="/opt/consul/bin"
CONSUL_VERSION="0.7.1"
CONSUL_DOWNLOAD_URL="https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip"

VAULT_BIN_DIR="/opt/vault/bin"
VAULT_VERSION="0.6.4"
VAULT_DOWNLOAD_URL="https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip"

sudo yum install -y epel-release
sudo yum install -y vim-enhanced
sudo yum -y install net-tools
sudo yum install -y unzip

# Hashicorp Vault install
sudo curl -k $VAULT_DOWNLOAD_URL -o my-vault.zip

if [ ! -d "$VAULT_BIN_DIR" ]; then
  sudo mkdir -p $VAULT_BIN_DIR
  sudo unzip my-vault.zip -d $VAULT_BIN_DIR
fi

if [ $(getent passwd vault | wc -l) -eq 0 ]; then
  sudo useradd vault
  sudo echo "PATH=$PATH:${VAULT_BIN_DIR}" >> /home/vault/.bashrc
  sudo chown -R vault. /opt/vault
  sudo -u vault cat > /home/vault/vault-consul-config.json <<EOF
# Vault Consul demo config file
  backend "consul" {
    address = "192.168.35.30:8500"
    advertise_addr=http
    path = "vault"
  }

  listener "tcp" {
    address = "192.168.35.30:8200"
    tls_disable = 1
  }

  telemetry {
    statsite_address = "192.168.35.30:8125"
    disable_hostname = true
  }

disable_mlock = true
EOF
fi

# Hashicorp Consul install
sudo curl -k $CONSUL_DOWNLOAD_URL -o my-consul.zip

if [ ! -d "$CONSUL_BIN_DIR" ]; then
  sudo mkdir -p $CONSUL_BIN_DIR
  sudo unzip my-consul.zip -d $CONSUL_BIN_DIR
fi

if [ $(getent passwd consul | wc -l) -eq 0 ]; then
  sudo useradd consul
  sudo echo "PATH=$PATH:${CONSUL_BIN_DIR}" >> /home/consul/.bashrc
  sudo chown -R consul. /opt/consul
fi
