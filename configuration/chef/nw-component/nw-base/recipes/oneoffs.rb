#
# Cookbook Name:: nw-base
# Recipe:: oneoffs
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

service 'Fix hostname in rsyslog' do
  service_name 'rsyslog'
  action :restart
  provider Chef::Provider::Service::Systemd
end
