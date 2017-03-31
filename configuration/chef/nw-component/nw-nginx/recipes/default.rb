#
# Cookbook Name:: nw-nginx
# Recipe:: default
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'nw-nginx::accounts'
include_recipe 'nw-nginx::packages'
include_recipe 'nw-nginx::firewall'
include_recipe 'nw-nginx::filesystem'
include_recipe 'nw-nginx::install'
include_recipe 'nw-nginx::services'
include_recipe 'nw-nginx::serviceinfo'
