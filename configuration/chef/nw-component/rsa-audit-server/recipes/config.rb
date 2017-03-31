#
# Cookbook Name:: rsa-audit-server
# Recipe:: config
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

# create directory for storing keystores
directory '/etc/logstash/conf.d' do
  owner 'logstash'
  group 'logstash'
  mode 0o750
  action :create
  recursive true
end

# needed to satisfy ChefSpec
service node['rsa-audit-server']['service_names'].first do
  action :nothing
  provider Chef::Provider::Service::Systemd
end

# deploy logstash configuration file
cookbook_file '/etc/logstash/conf.d/rsa-audit-server.conf' do
  source 'rsa-audit-server.conf'
  owner 'logstash'
  group 'logstash'
  mode 0o640
  notifies :restart, 'service[logstash]', :delayed
end