#
# Cookbook Name:: salt-minion
# Recipe:: default
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'salt-minion::accounts'
include_recipe 'salt-minion::packages'
include_recipe 'salt-minion::firewall'
include_recipe 'salt-minion::filesystem'
include_recipe 'salt-minion::services'

