#
# Cookbook Name:: nw-log-collector
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

template '/etc/collectd.d/logcollector.conf' do
  source 'logcollector.conf.erb'
  owner 'root'
  group 'root'
  mode 0o444
  variables(
    certfile: cert,
    keyfile: key
  )
  notifies :restart, 'service[collectd]', :delayed
end

cookbook_file '/etc/collectd.d/logcollector-queues.conf' do
  source 'logcollector-queues.conf'
  owner 'root'
  group 'root'
  mode 0o444
  notifies :restart, 'service[collectd]', :delayed
end

python_scripts = %w(logcollector logcollector_lockbox)
python_scripts.each do |py|
  remote_file "/usr/lib/collectd/python/comp_modules/cs_#{py}.py" do
    source "file:///usr/lib/collectd/python/cs_#{py}.py"
    owner 'root'
    group 'root'
    mode 0o444
    notifies :restart, 'service[collectd]', :delayed
  end
end
