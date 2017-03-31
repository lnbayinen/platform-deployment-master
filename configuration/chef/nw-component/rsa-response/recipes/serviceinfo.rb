#
# Cookbook Name:: rsa-response
# Recipe:: serviceinfo
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

component_name = node['rsa-response']['component_name']

serviceinfo_directory = "/etc/netwitness/platform/nodeinfo/#{component_name}"
serviceuuid_filepath = "#{serviceinfo_directory}/service-id"

serviceuuid_source_filepath = "/etc/netwitness/#{component_name}/service-id"

directory "#{serviceinfo_directory}" do
  action :create
  recursive true
end


file "#{serviceuuid_filepath}" do
  content lazy { "service-id=" + ::File.open("#{serviceuuid_source_filepath}").read }
  mode '0640'
  action :create
  retries 90
  retry_delay 2
end