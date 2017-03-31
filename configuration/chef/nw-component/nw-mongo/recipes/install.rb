#
# Cookbook Name:: nw-mongo
# Recipe:: install
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

# Remove upstart style init script
cookbook_file '/etc/init.d/mongod' do
  action :delete
end

cookbook_file '/etc/sysconfig/mongod' do
  source 'mongod.defaults'
  owner 'root'
  group 'root'
  mode '0644'
end

cookbook_file '/lib/systemd/system/mongod.service' do
  source 'mongod.service'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :run, 'execute[daemon_reload]', :immediately
end

template '/etc/mongod.conf' do
  source 'mongod.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

execute 'daemon_reload' do
  command 'systemctl --system daemon-reload'
  action :nothing
end
