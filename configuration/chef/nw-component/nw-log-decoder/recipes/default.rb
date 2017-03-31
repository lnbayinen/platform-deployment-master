#
# Cookbook Name:: nw-log-decoder
# Recipe:: default
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'nw-log-decoder::accounts'
include_recipe 'nw-log-decoder::packages'
include_recipe 'nw-log-decoder::firewall'
include_recipe 'nw-log-decoder::filesystem'
include_recipe 'nw-log-decoder::services'
include_recipe 'nw-log-decoder::serviceinfo'
include_recipe 'nw-log-decoder::collectd'
