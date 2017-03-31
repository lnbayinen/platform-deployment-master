#
# Cookbook Name:: nw-re-server
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

template '/etc/collectd.d/jmx-ReportingEngine.conf' do
  source 'jmx-ReportingEngine.conf.erb'
  owner 'root'
  group 'root'
  mode 0o444
  variables(
    node_uuid: node['global']['host']['id']
  )
  notifies :restart, 'service[collectd]', :delayed
end

remote_file '/usr/lib/collectd/python/comp_modules/cs_reportingengine.py' do
  source 'file:///usr/lib/collectd/python/cs_reportingengine.py'
  owner 'root'
  group 'root'
  mode 0o444
  notifies :restart, 'service[collectd]', :delayed
end
