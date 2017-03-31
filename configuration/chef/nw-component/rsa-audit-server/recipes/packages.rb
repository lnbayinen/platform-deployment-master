#
# Cookbook Name:: rsa-audit-server
# Recipe:: packages
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

node['rsa-audit-server']['packages'].each do |pkg|
  package pkg['name'] do
    version pkg['version']
    action :install
  end
end
