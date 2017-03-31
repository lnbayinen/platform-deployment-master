#
# Cookbook Name:: tmpwatch
# Recipe:: default
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'tmpwatch::accounts'
include_recipe 'tmpwatch::packages'
include_recipe 'tmpwatch::firewall'
include_recipe 'tmpwatch::filesystem'
include_recipe 'tmpwatch::services'
include_recipe 'tmpwatch::config'
