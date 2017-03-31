#
# Cookbook Name:: nw-base
# Recipe:: default
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'nw-base::collectd'
include_recipe 'nw-base::packages'
include_recipe 'nw-base::firewall'
include_recipe 'nw-base::filesystem'
include_recipe 'nw-base::oneoffs'
