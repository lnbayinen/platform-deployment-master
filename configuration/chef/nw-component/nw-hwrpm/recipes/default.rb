#
# Cookbook Name:: nw-hwrpm
# Recipe:: default
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'nw-hwrpm::accounts'
include_recipe 'nw-hwrpm::packages'
include_recipe 'nw-hwrpm::configure'
include_recipe 'nw-hwrpm::firewall'
include_recipe 'nw-hwrpm::filesystem'
include_recipe 'nw-hwrpm::services'
