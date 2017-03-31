#
# Cookbook Name:: nw-security-bootstrap
# Recipe:: bootstrap
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

ssc_config = node['nw-pki']['ss_client']
service_name = node['nw-security-bootstrap']['service_names'].first

env_opts = {
    :RSA_TRANSPORT_HTTP_ENABLED => true,
    :RSA_TRANSPORT_HTTP_SECURE => true,
    :RSA_SERVICE_PASSWORD => ssc_config['password']
}

systemd_service "#{service_name}-security-bootstrap-managed" do
  drop_in true
  override service_name
  service do
    environment env_opts
  end
  sensitive true
end

service service_name do
  action :restart
  provider Chef::Provider::Service::Systemd
end