#
# Cookbook Name:: nw-re-server
# Recipe:: serviceinfo
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

component_name = node['nw-re-server']['component_name']

serviceinfo_directory = "/etc/netwitness/platform/nodeinfo/#{component_name}"
serviceuuid_filepath = "#{serviceinfo_directory}/service-id"

directory serviceinfo_directory do
  action :create
  recursive true
end

file serviceuuid_filepath do
  content "service-id=#{SecureRandom.uuid}"
  mode '0640'
  action :create_if_missing
end