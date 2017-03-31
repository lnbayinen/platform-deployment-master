#
# Cookbook Name:: rsa-audit-server
# Recipe:: default
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'rsa-audit-server::accounts'
include_recipe 'rsa-audit-server::packages'
include_recipe 'rsa-audit-server::firewall'
include_recipe 'rsa-audit-server::filesystem'
include_recipe 'rsa-audit-server::services'
include_recipe 'rsa-audit-server::config'
