#
# Cookbook Name:: nw-ntp
# Recipe:: default
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'nw-ntp::accounts'
include_recipe 'nw-ntp::packages'
include_recipe 'nw-ntp::firewall'
include_recipe 'nw-ntp::filesystem'
include_recipe 'nw-ntp::config'
include_recipe 'nw-ntp::services'
