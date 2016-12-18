#!/bin/sh

# Wrapping vault-dev for demo purposes

VAULT_BIN_DIR="/opt/vault/bin"
VAULT_VERSION="0.6.4"
VAULT_DOWNLOAD_URL="https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip"

sudo yum install -y epel-release
sudo yum install -y vim-enhanced
sudo yum -y install net-tools
sudo yum install -y unzip

sudo curl -kO $VAULT_DOWNLOAD_URL

if [ ! -d "$VAULT_BIN_DIR" ]; then
  sudo mkdir -p $VAULT_BIN_DIR
  sudo unzip vault_${VAULT_VERSION}_linux_amd64.zip -d $VAULT_BIN_DIR
fi

if [ $(getent passwd vault | wc -l) = 0 ]; then
  sudo useradd vault
  sudo chown -R vault. /opt/vault
  sudo -u vault echo "PATH=$PATH:/opt/vault/bin" >> /home/vault/.bashrc
  sudo -u vault cat > /home/vault/vault-config.json <<EOF
# Vault demo config file
backend "file" {
  path = "vault"
}

listener "tcp" {
  address = "192.168.35.20:8200"
  tls_disable = 1
}

EOF
fi
