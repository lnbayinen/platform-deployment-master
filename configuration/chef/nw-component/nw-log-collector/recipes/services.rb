#
# Cookbook Name:: nw-log-collector
# Recipe:: services
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

env_opts = node['nw-log-collector']['environment_opts']

node['nw-log-collector']['service_names'].each do |svc|
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
