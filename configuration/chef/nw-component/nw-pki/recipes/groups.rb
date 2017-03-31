#
# Cookbook Name:: nw-pki
# Recipe:: groups
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

node['nw-pki']['user_groups'].each do |user_group|
  group user_group['name'] do
    gid user_group['gid']
    members user_group['members']
    append true
  end
end
