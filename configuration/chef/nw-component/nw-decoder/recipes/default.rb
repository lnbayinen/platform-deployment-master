#
# Cookbook Name:: nw-decoder
# Recipe:: default
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'nw-decoder::accounts'
include_recipe 'nw-decoder::packages'
include_recipe 'nw-decoder::firewall'
include_recipe 'nw-decoder::filesystem'
include_recipe 'nw-decoder::services'
include_recipe 'nw-decoder::serviceinfo'
include_recipe 'nw-decoder::collectd'
