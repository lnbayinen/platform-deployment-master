#
# Cookbook Name:: nw-rabbitmq
# Recipe:: vhosts
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

node['nw-rabbitmq']['vhosts'].each do |vhost|
  nw_rabbitmq_vhost vhost do
    action :add
  end
end
