#
# Cookbook Name:: rsa-config-server
# Recipe:: default
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'rsa-config-server::accounts'
include_recipe 'rsa-config-server::packages'
include_recipe 'rsa-config-server::firewall'
include_recipe 'rsa-config-server::filesystem'
include_recipe 'rsa-config-server::services'
include_recipe 'rsa-config-server::serviceinfo'
