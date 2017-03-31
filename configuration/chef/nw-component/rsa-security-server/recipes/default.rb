#
# Cookbook Name:: rsa-security-server
# Recipe:: default
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'rsa-security-server::accounts'
include_recipe 'rsa-security-server::packages'
include_recipe 'rsa-security-server::firewall'
include_recipe 'rsa-security-server::filesystem'
include_recipe 'rsa-security-server::services'
include_recipe 'rsa-security-server::serviceinfo'
