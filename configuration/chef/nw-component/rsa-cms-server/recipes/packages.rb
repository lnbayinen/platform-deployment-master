#
# Cookbook Name:: rsa-cms-server
# Recipe:: packages
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

node['rsa-cms-server']['packages'].each do |pkg|
  package pkg['name'] do
    version pkg['version']
    action :install
  end
end
