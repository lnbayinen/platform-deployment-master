#
# Cookbook Name:: nw-appliance
# Recipe:: default
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'nw-appliance::accounts'
include_recipe 'nw-appliance::groups'
include_recipe 'nw-appliance::packages'
include_recipe 'nw-appliance::firewall'
include_recipe 'nw-appliance::filesystem'
include_recipe 'nw-appliance::services'
include_recipe 'nw-appliance::serviceinfo'
