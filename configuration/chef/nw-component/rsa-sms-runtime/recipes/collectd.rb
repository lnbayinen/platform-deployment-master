#
# Cookbook Name:: rsa-sms-runtime
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

cookbook_file '/etc/collectd.d/appliance.conf' do
  source 'appliance.conf'
  owner 'root'
  group 'root'
  mode 0o644
  notifies :restart, 'service[collectd]', :delayed
end

cookbook_file '/etc/collectd.d/appliance_diskraid.conf' do
  source 'appliance_diskraid.conf'
  owner 'root'
  group 'root'
  mode 0o644
  notifies :restart, 'service[collectd]', :delayed
end

file '/etc/collectd.d/_collectd_filter.conf' do
  action :delete
end

cookbook_file '/etc/collectd.d/_collectd_pre_filter.conf' do
  source '_collectd_pre_filter.conf'
  owner 'root'
  group 'root'
  mode 0o644
  notifies :restart, 'service[collectd]', :delayed
end

cookbook_file '/etc/collectd.d/_collectd_logfile.conf.disabled' do
  source '_collectd_logfile.conf'
  owner 'root'
  group 'root'
  mode 0o644
  notifies :restart, 'service[collectd]', :delayed
end

cookbook_file '/etc/collectd.d/MessageBus.conf' do
  source 'MessageBus.conf'
  owner 'root'
  group 'root'
  mode 0o644
  notifies :restart, 'service[collectd]', :delayed
end

cookbook_file '/etc/collectd.d/MessageBusWriteModule.conf' do
  source 'MessageBusWriteModule.conf'
  owner 'root'
  group 'root'
  mode 0o644
  notifies :restart, 'service[collectd]', :delayed
end

cookbook_file '/etc/collectd.d/SampleReadModule.conf.disabled' do
  source 'SampleReadModule.conf'
  owner 'root'
  group 'root'
  mode 0o644
  notifies :restart, 'service[collectd]', :delayed
end

cookbook_file '/etc/collectd.d/SampleWriteModule.conf.disabled' do
  source 'SampleWriteModule.conf'
  owner 'root'
  group 'root'
  mode 0o644
  notifies :restart, 'service[collectd]', :delayed
end

cookbook_file '/etc/collectd.d/SampleEsmReader.conf.disabled' do
  source 'SampleEsmReader.conf'
  owner 'root'
  group 'root'
  mode 0o644
  notifies :restart, 'service[collectd]', :delayed
end

directory '/usr/lib/collectd/python/comp_modules' do
  owner 'root'
  group 'root'
  mode 0o644
  recursive true
  action :create
end

remote_file '/usr/lib/collectd/python/comp_modules/cs_appliance.py' do
  source 'file:///usr/lib/collectd/python/cs_appliance.py'
  owner 'root'
  group 'root'
  mode 0o444
  notifies :restart, 'service[collectd]', :delayed
end

cookbook_file '/etc/collectd.d/NwCompositeStats.conf' do
  source 'NwCompositeStats.conf'
  owner 'root'
  group 'root'
  mode 0o644
  notifies :restart, 'service[collectd]', :delayed
end

cookbook_file '/etc/collectd.d/_collectd_java.conf' do
  source '_collectd_java.conf'
  owner 'root'
  group 'root'
  mode 0o644
  notifies :restart, 'service[collectd]', :delayed
end
