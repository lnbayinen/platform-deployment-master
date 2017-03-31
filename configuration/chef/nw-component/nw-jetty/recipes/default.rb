#
# Cookbook Name:: nw-jetty
# Recipe:: default
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'nw-jetty::accounts'
include_recipe 'nw-jetty::packages'
include_recipe 'nw-jetty::firewall'
include_recipe 'nw-jetty::filesystem'
include_recipe 'nw-jetty::install'
include_recipe 'nw-jetty::services'
include_recipe 'nw-jetty::serviceinfo'
include_recipe 'nw-jetty::collectd'
