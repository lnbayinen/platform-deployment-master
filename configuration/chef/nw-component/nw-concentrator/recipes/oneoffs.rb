#
# Cookbook Name:: nw-concentrator
# Recipe:: oneoffs
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

directory '/var/netwitness/concentrator/metadb' do
  recursive true
  action :create
end
