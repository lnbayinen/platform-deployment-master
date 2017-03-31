#
# Cookbook Name:: nw-event-stream-analysis
# Recipe:: packages
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

node['nw-event-stream-analysis']['packages'].each do |pkg|
  package pkg['name'] do
    version pkg['version']
    action :install
    timeout 21600
  end
end
