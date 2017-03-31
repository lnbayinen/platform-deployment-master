#
# Cookbook Name:: nw-workbench
# Recipe:: default
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'nw-workbench::accounts'
include_recipe 'nw-workbench::packages'
include_recipe 'nw-workbench::oneoffs'
include_recipe 'nw-workbench::firewall'
include_recipe 'nw-workbench::filesystem'
include_recipe 'nw-workbench::services'
include_recipe 'nw-workbench::serviceinfo'
include_recipe 'nw-workbench::collectd'
