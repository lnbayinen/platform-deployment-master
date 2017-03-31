#
# Cookbook Name:: nw-rabbitmq
# Recipe:: policies
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

node['nw-rabbitmq']['policies'].each do |policy|
  nw_rabbitmq_policy policy['name'] do
    pattern policy['pattern']
    params policy['params']
    priority policy['priority'] || nil
    vhost policy['vhost'] || nil
    apply_to policy['apply_to'] || nil
    action :set
  end
end
