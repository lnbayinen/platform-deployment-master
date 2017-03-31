#
# Cookbook Name:: nw-rabbitmq
# Recipe:: users
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

node['nw-rabbitmq']['users'].each do |user|
  userpass = nil
  if user.key?('password') && !user['password'].empty?
    userpass = user['password']
  end

  nw_rabbitmq_user "add #{user['name']}" do
    # A password value is required for `rabbitmqctl add_user`, so if
    # the supplied value is nil, provide a stub and subsequently
    # clear it.
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
  vhosts.each do |rmq_vhost|
    nw_rabbitmq_user "set_permissions #{user['name']}" do
      user user['name']
      vhost rmq_vhost['name']
      permissions rmq_vhost['permissions']
      action :set_permissions
    end
  end
end
