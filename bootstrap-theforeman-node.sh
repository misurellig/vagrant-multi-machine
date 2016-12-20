#!/bin/sh

# Run custom configs in case

sudo yum install -y epel-release
sudo yum install -y vim-enhanced
sudo yum -y install net-tools

# Install The Foreman version 1.13 with chef plugin
sudo yum localinstall https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
sudo yum -y install epel-release https://yum.theforeman.org/releases/1.13/el7/x86_64/foreman-release.rpm
sudo yum -y install foreman-installer
sudo foreman-installer --enable-foreman-plugin-chef
