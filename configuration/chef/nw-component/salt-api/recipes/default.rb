#
# Cookbook Name:: salt-api
# Recipe:: default
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'salt-api::accounts'
include_recipe 'salt-api::packages'
include_recipe 'salt-api::firewall'
include_recipe 'salt-api::filesystem'
include_recipe 'salt-api::services'
