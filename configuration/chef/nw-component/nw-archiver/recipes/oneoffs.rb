#
# Cookbook Name:: nw-archiver
# Recipe:: oneoffs
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

directory '/var/netwitness/archiver/metadb/database0' do
  recursive true
  action :create
end
