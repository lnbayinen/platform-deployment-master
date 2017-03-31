#
# Cookbook Name:: nw-event-stream-analysis
# Recipe:: collectd
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

# needed to satisfy ChefSpec
service 'collectd' do
  action :nothing
  provider Chef::Provider::Service::Systemd
end

template '/etc/collectd.d/esa.conf' do
  source 'esa.conf.erb'
  owner 'root'
  group 'root'
  mode 0o444
  variables(
    node_uuid: node['global']['host']['id']
  )
  notifies :restart, 'service[collectd]', :delayed
end

remote_file '/usr/lib/collectd/python/comp_modules/cs_esa.py' do
  source 'file:///usr/lib/collectd/python/cs_esa.py'
  owner 'root'
  group 'root'
  mode 0o444
  notifies :restart, 'service[collectd]', :delayed
end
