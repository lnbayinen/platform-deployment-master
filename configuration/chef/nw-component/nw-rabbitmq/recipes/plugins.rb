#
# Cookbook Name:: nw-rabbitmq
# Recipe:: plugins
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

node['nw-rabbitmq']['plugins'].each do |plugin|
  nw_rabbitmq_plugin plugin do
    action :enable
  end
end
