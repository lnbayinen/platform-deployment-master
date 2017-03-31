#
# Cookbook Name:: nw-rabbitmq
# Recipe:: config
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

service_name = format(
  'service[%s]', node['nw-rabbitmq']['service_names'].first
)

# needed to satisfy ChefSpec
service node['nw-rabbitmq']['service_names'].first do
  action :nothing
  provider Chef::Provider::Service::Systemd
end

svcacct = node['nw-rabbitmq']['accounts'].first

template '/etc/rabbitmq/rabbitmq.config' do
  sensitive true
  source 'rabbitmq.config.erb'
  owner svcacct['name']
  group svcacct['name']
  mode 0o440
  variables(
    amqp_port: node['nw-rabbitmq']['amqp_port'],
    amqps_port: node['nw-rabbitmq']['amqps_port'],
    mgmt_port: node['nw-rabbitmq']['mgmt_port'],
    cacertfile: node['nw-rabbitmq']['cacertfile'],
    certfile: node['nw-rabbitmq']['certfile'],
    keyfile: node['nw-rabbitmq']['keyfile'],
    tls_vers: node['nw-rabbitmq']['tls_versions'],
    ciphers: node['nw-rabbitmq']['ciphers']
  )
  notifies :restart, service_name, :immediately
end
