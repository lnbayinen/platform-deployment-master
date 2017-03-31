#
# Cookbook Name:: nw-jetty
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

template '/etc/collectd.d/jmx-SAServer.conf' do
  source 'jmx-SAServer.conf.erb'
  owner 'root'
  group 'root'
  mode 0o444
  variables(
    node_uuid: node['global']['host']['id']
  )
  notifies :restart, 'service[collectd]', :delayed
end
