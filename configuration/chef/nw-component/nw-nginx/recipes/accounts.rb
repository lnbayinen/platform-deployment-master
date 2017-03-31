#
# Cookbook Name:: nw-nginx
# Recipe:: accounts
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

node['nw-nginx']['accounts'].each do |account|
  group account['name'] do
    gid account['uid']
  end

  user account['name'] do
    comment "RSA #{account['name']} service account"
    home account['home'] if account.key?('home')
    manage_home account['manage_home'] if account.key?('manage_home')
    shell '/bin/bash'
    uid account['uid']
    gid account['uid']
  end
end
