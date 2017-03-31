#
# Cookbook Name:: nw-broker
# Recipe:: default
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'nw-broker::accounts'
include_recipe 'nw-broker::packages'
include_recipe 'nw-broker::firewall'
include_recipe 'nw-broker::filesystem'
include_recipe 'nw-broker::services'
include_recipe 'nw-broker::serviceinfo'
include_recipe 'nw-broker::collectd'
