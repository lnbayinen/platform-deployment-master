#
# Cookbook Name:: nw-log-decoder
# Recipe:: collectd
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

common_cert = node['nw-pki']['certificates'].select do |c|
  c.key?('node_common') && c['node_common']
end

log 'Unable to find Common Node Certificate' do
  level :fatal
  only_if { common_cert.empty? }
end

cert = common_cert.first['cert_pem']
key = common_cert.first['key_pem']

# needed to satisfy ChefSpec
service 'collectd' do
  action :nothing
  provider Chef::Provider::Service::Systemd
end

template '/etc/collectd.d/logdecoder.conf' do
  source 'logdecoder.conf.erb'
  owner 'root'
  group 'root'
  mode 0o444
  variables(
    certfile: cert,
    keyfile: key
  )
  notifies :restart, 'service[collectd]', :delayed
end

template '/etc/collectd.d/logdecoder-esm.conf' do
  source 'logdecoder-esm.conf.erb'
  owner 'root'
  group 'root'
  mode 0o444
  variables(
    certfile: cert,
    keyfile: key
  )
  notifies :restart, 'service[collectd]', :delayed
end

remote_file '/usr/lib/collectd/python/comp_modules/cs_logdecoder.py' do
  source 'file:///usr/lib/collectd/python/cs_logdecoder.py'
  owner 'root'
  group 'root'
  mode 0o444
  notifies :restart, 'service[collectd]', :delayed
end
