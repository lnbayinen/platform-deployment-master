#
# Cookbook Name:: nw-security-bootstrap
# Recipe:: cleanup
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

service_name = node['nw-security-bootstrap']['service_names'].first

systemd_service "#{service_name}-security-bootstrap-managed" do
  drop_in true
  override service_name
  sensitive true
  action :delete
end

service service_name do
  action :restart
  provider Chef::Provider::Service::Systemd
end
