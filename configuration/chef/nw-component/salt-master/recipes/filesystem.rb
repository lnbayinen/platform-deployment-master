#
# Cookbook Name:: salt-master
# Recipe:: filesystem
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

nw_base_filesystem 'salt-master' do
  action :apply
end
