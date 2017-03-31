#
# Cookbook Name:: nw-log-decoder
# Recipe:: packages
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

node['nw-log-decoder']['packages'].each do |pkg|
  package pkg['name'] do
    version pkg['version']
    action :install
  end
end
