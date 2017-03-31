#
# Cookbook Name:: salt-minion
# Recipe:: filesystem
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

nw_base_filesystem 'salt-minion' do
  action :apply
end
