#
# Cookbook Name:: rsa-orchestration-server
# Recipe:: config
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

service_name = format(
  'service[%s]', node['rsa-orchestration-server']['service_names'].first
)

service node['rsa-orchestration-server']['service_names'].first do
  action :nothing
  provider Chef::Provider::Service::Systemd
end

repourl = (node['global'] && node['global']['yum-repo-url']) ?
    node['global']['yum-repo-url'] : node['nw-repositories']['repos']['rsanw']['baseurl']

template '/etc/netwitness/orchestration-server/orchestration-server.yml' do
  source 'orchestration.yml.erb'
  mode 0o644
  variables(
      repourl: repourl
  )
  notifies :restart, service_name, :delayed
end