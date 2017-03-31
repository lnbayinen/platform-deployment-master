#
# Cookbook Name:: rsa-cms-server
# Recipe:: default
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'rsa-cms-server::accounts'
include_recipe 'rsa-cms-server::packages'
include_recipe 'rsa-cms-server::firewall'
include_recipe 'rsa-cms-server::filesystem'
include_recipe 'rsa-cms-server::services'
