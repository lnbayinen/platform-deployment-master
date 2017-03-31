#
# Cookbook Name:: rsa-sms-server
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

directory '/var/lib/netwitness/collectd/rrd' do
  recursive true
  owner 'root'
  group 'root'
  mode 0o644
  action :create
end

template '/etc/collectd.d/jmx-SystemMonitor.conf' do
  source 'jmx-SystemMonitor.conf.erb'
  owner 'root'
  group 'root'
  mode 0o644
  variables(
    node_uuid: node['global']['host']['id']
  )
  notifies :restart, 'service[collectd]', :delayed
end

cookbook_file '/etc/collectd.d/ESMAggregator.conf' do
  source 'ESMAggregator.conf'
  owner 'root'
  group 'root'
  mode 0o644
  notifies :restart, 'service[collectd]', :delayed
end

cookbook_file '/etc/collectd.d/SmsAggregator.conf' do
  source 'SmsAggregator.conf'
  owner 'root'
  group 'root'
  mode 0o644
  notifies :restart, 'service[collectd]', :delayed
end

cookbook_file '/etc/collectd.d/MessageBusReadModule.conf' do
  source 'MessageBusReadModule.conf'
  owner 'root'
  group 'root'
  mode 0o644
  notifies :restart, 'service[collectd]', :delayed
end

cookbook_file '/etc/collectd.d/_collectd_rrdtool.conf' do
  source '_collectd_rrdtool.conf'
  owner 'root'
  group 'root'
  mode 0o644
  notifies :restart, 'service[collectd]', :delayed
end

cookbook_file '/etc/collectd.d/_collectd_post_filter_smsnode.conf' do
  source '_collectd_post_filter_smsnode.conf'
  owner 'root'
  group 'root'
  mode 0o644
  notifies :restart, 'service[collectd]', :delayed
end

remote_file '/usr/lib/collectd/python/comp_modules/cs_appliances_down.py' do
  source 'file:///usr/lib/collectd/python/cs_appliances_down.py'
  owner 'root'
  group 'root'
  mode 0o444
  notifies :restart, 'service[collectd]', :delayed
end
