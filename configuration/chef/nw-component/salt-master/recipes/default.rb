#
# Cookbook Name:: salt-master
# Recipe:: default
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'salt-master::accounts'
include_recipe 'salt-master::packages'
include_recipe 'salt-master::firewall'
include_recipe 'salt-master::filesystem'
include_recipe 'salt-master::install'
include_recipe 'salt-master::services'
