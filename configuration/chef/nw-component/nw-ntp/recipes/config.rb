#
# Cookbook Name:: nw-ntp
# Recipe::config
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

hostname = 'server nw-node-zero'
hostname = '#server <ip address>' if node['packages'].key?('salt_master')

template '/etc/ntp.conf' do
  source 'ntp.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  variables(
    node0_host: hostname
  )
end
