#
# Cookbook Name:: nw-re-server
# Recipe:: default
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'nw-re-server::accounts'
include_recipe 'nw-re-server::packages'
include_recipe 'nw-re-server::firewall'
include_recipe 'nw-re-server::filesystem'
include_recipe 'nw-re-server::services'
include_recipe 'nw-re-server::serviceinfo'
include_recipe 'nw-re-server::collectd'
