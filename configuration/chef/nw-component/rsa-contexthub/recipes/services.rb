#
# Cookbook Name:: rsa-contexthub
# Recipe:: services
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

env_opts = node['rsa-contexthub']['environment_opts']

rabbitmq_component_name = node['nw-rabbitmq']['component_name']
rabbitmq_host = node[:global][rabbitmq_component_name] ? node[:global][rabbitmq_component_name][:host][:hostname] : nil
rabbitmq_port = node[:global][rabbitmq_component_name] ? node[:global][rabbitmq_component_name][:port] : nil

mongo_component_name = node['nw-mongo']['component_name']
mongo_host = node[:global][rabbitmq_component_name] ? node[:global][mongo_component_name][:host][:hostname] : nil
mongo_port = node[:global][rabbitmq_component_name] ? node[:global][mongo_component_name][:port] : nil

system_opts = {}
env_opts.each do |key, value|
  system_opts[key] = value
end

system_opts[:RSA_TRANSPORT_BUS_HOST] = rabbitmq_host if rabbitmq_host
system_opts[:RSA_TRANSPORT_BUS_PORT] = rabbitmq_port if rabbitmq_port
system_opts[:RSA_DATA_SERVERS] = mongo_host if mongo_host
system_opts[:RSA_DATA_PORT] = mongo_port if mongo_port

node['rsa-contexthub']['service_names'].each do |svc|
  systemd_service "#{svc}-opts-managed" do
    drop_in true
    override svc
    service do
      environment system_opts
    end
    not_if { system_opts.empty? }
  end

  service svc do
    action [:enable, :start]
    provider Chef::Provider::Service::Systemd
    subscribes :restart, "systemd_service[#{svc}-opts-managed]"
  end
end
