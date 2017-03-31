#
# Cookbook Name:: rsa-orchestration-server
# Recipe:: services
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

env_opts = node['rsa-orchestration-server']['environment_opts']

node['rsa-orchestration-server']['service_names'].each do |svc|
  systemd_service "#{svc}-opts-managed" do
    drop_in true
    override svc
    service do
      environment env_opts
    end
    not_if { env_opts.empty? }
  end

  service svc do
    action [:enable, :start]
    provider Chef::Provider::Service::Systemd
    subscribes :restart, "systemd_service[#{svc}-opts-managed]"
  end
end
