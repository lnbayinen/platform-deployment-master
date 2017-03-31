#
# Cookbook Name:: rsa-admin-server
# Recipe:: default
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'rsa-admin-server::accounts'
include_recipe 'rsa-admin-server::packages'
include_recipe 'rsa-admin-server::firewall'
include_recipe 'rsa-admin-server::filesystem'
include_recipe 'rsa-admin-server::services'
include_recipe 'rsa-admin-server::serviceinfo'
