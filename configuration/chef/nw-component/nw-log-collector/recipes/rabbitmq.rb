#
# Cookbook Name:: nw-log-collector
# Recipe:: rabbitmq
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

node['nw-log-collector']['rabbitmq']['vhosts'].each do |vhost|
  nw_rabbitmq_vhost vhost do
    action :add
  end
end

node['nw-log-collector']['rabbitmq']['users'].each do |user|
  userpass = nil
  if user.key?('password') && !user['password'].empty?
    userpass = user['password']
  end

  nw_rabbitmq_user "add #{user['name']}" do
    name user['name']
    password userpass || 'netwitness'
    action :add
  end

  nw_rabbitmq_user "clear_password #{user['name']}" do
    action :clear_password
    only_if { userpass.nil? }
  end

  nw_rabbitmq_user "set_tags #{user['name']}" do
    user user['name']
    tag 'administrator'
    action :set_tags
    only_if { user.key?('administrator') && user['administrator'] }
  end

  vhosts = user['vhosts'] || []
  vhosts.each do |vhost|
    nw_rabbitmq_user "set_permissions #{user['name']} on #{vhost['name']}" do
      user user['name']
      vhost vhost['name']
      permissions vhost['permissions']
      action :set_permissions
    end
  end
end

node['nw-log-collector']['rabbitmq']['policies'].each do |policy|
  nw_rabbitmq_policy policy['name'] do
    vhost policy['vhost']
    pattern policy['pattern']
    params policy['params']
    apply_to policy['apply_to']
    priority policy['priority']
  end
end

# Ensure the internal packages list is reloaded so we can access package
# details
ohai 'reload package list' do
  action :reload
  plugin 'packages'
  not_if do
    node['packages'].key?('rabbitmq-server') &&
      node['packages'].key?('nwlogcollector')
  end
end

# Guard against missing packages
rmq_version = lc_version = nil
if node['packages'].key?('rabbitmq-server')
  rmq_version = node['packages']['rabbitmq-server']['version']
end
if node['packages'].key?('nwlogcollector')
  lc_version = node['packages']['nwlogcollector']['version']
end

plugin_dir = "/usr/lib/rabbitmq/lib/rabbitmq_server-#{rmq_version}/plugins"
plugin_file = File.join(plugin_dir, 'nw_admin.ez')
plugin_source = "/opt/netwitness/nw_admin-#{lc_version}.ez"

# Don't do this if the RabbitMQ package wasn't found
directory plugin_dir do
  recursive true
  action :create
  not_if { rmq_version.nil? || lc_version.nil? }
end

nw_rabbitmq_plugin 'nw_admin' do
  action :nothing
end

remote_file plugin_file do
  source "file://#{plugin_source}"
  owner 'root'
  group 'root'
  mode 0o444
  notifies :enable, 'nw_rabbitmq_plugin[nw_admin]', :immediately
  not_if { rmq_version.nil? || lc_version.nil? }
end
