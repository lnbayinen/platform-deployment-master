#
# Cookbook Name:: nw-workbench
# Recipe:: oneoffs
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

directory '/var/netwitness/workbench/collections' do
  recursive true
  action :create
end
