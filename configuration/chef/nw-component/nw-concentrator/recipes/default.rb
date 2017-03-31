#
# Cookbook Name:: nw-concentrator
# Recipe:: default
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'nw-concentrator::accounts'
include_recipe 'nw-concentrator::packages'
include_recipe 'nw-concentrator::oneoffs'
include_recipe 'nw-concentrator::firewall'
include_recipe 'nw-concentrator::filesystem'
include_recipe 'nw-concentrator::services'
include_recipe 'nw-concentrator::serviceinfo'
include_recipe 'nw-concentrator::collectd'
