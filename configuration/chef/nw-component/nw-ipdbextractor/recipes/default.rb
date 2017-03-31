#
# Cookbook Name:: nw-ipdbextractor
# Recipe:: default
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'nw-ipdbextractor::accounts'
include_recipe 'nw-ipdbextractor::packages'
include_recipe 'nw-ipdbextractor::firewall'
include_recipe 'nw-ipdbextractor::filesystem'
include_recipe 'nw-ipdbextractor::services'
include_recipe 'nw-ipdbextractor::serviceinfo'
include_recipe 'nw-ipdbextractor::collectd'
