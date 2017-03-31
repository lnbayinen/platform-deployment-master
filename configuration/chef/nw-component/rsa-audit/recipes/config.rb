#
# Cookbook Name:: rsa-audit
# Recipe:: config
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

# create directory for storing keystores
directory '/etc/rsyslog.d' do
  owner 'root'
  group 'root'
  mode 0o750
  action :create
end

# needed to satisfy ChefSpec
service node['rsa-audit']['service_names'].first do
  action :nothing
  provider Chef::Provider::Service::Systemd
end

# deploy rsyslog.d configuration file
cookbook_file '/etc/rsyslog.d/rsa-udp-50514.conf' do
  source 'rsa-udp-50514.conf'
  owner 'root'
  group 'root'
  mode 0o640
  notifies :restart, 'service[rsyslog]', :delayed
end

# deploy rsyslog.d configuration template
template '/etc/rsyslog.d/rsa-sa-audit.conf' do
  source 'rsa-sa-audit.conf.erb'
  owner 'root'
  group 'root'
  variables(
      node_uuid: node['global']['host']['id']
  )
  mode 0o640
  notifies :restart, 'service[rsyslog]', :delayed
end
