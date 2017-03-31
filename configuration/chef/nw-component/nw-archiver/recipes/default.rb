#
# Cookbook Name:: nw-archiver
# Recipe:: default
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'nw-archiver::accounts'
include_recipe 'nw-archiver::packages'
include_recipe 'nw-archiver::oneoffs'
include_recipe 'nw-archiver::firewall'
include_recipe 'nw-archiver::filesystem'
include_recipe 'nw-archiver::services'
include_recipe 'nw-archiver::serviceinfo'
include_recipe 'nw-archiver::collectd'
