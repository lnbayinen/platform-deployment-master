#
# Cookbook Name:: nw-security-bootstrap
# Recipe:: packages
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

node['nw-security-bootstrap']['packages'].each do |pkg|
  package pkg['name'] do
    version pkg['version']
    action :install
  end
end
