#
# Cookbook Name:: nw-workbench
# Recipe:: packages
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

node['nw-workbench']['packages'].each do |pkg|
  package pkg['name'] do
    version pkg['version']
    action :install
  end
end
