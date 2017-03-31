#
# Cookbook Name:: nw-base
# Recipe:: collectd
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

directory '/usr/lib/collectd/python/comp_modules' do
  recursive true
  action :create
end

template '/etc/collectd.conf' do
  source 'collectd.conf.erb'
  owner 'root'
  group 'root'
  mode 0o444
  variables(
    node_uuid: node['global']['host']['id']
  )
end
