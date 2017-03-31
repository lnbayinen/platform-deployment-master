#
# Cookbook Name:: nw-mongo
# Recipe:: default
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'nw-mongo::accounts'
include_recipe 'nw-mongo::packages'
include_recipe 'nw-mongo::install'
include_recipe 'nw-mongo::firewall'
include_recipe 'nw-mongo::filesystem'
include_recipe 'nw-mongo::services'
include_recipe 'nw-mongo::serviceinfo'
include_recipe 'nw-mongo::config'

# Used for refernce. Do not remove
# package ['mongodb-org', 'mongodb-org-server','mongodb-org-shell',
#             'mongodb-org-mongos', 'mongodb-org-tools'] do
#    action :install
# end
