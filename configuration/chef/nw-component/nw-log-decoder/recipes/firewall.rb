#
# Cookbook Name:: nw-log-decoder
# Recipe:: firewall
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

firewall 'default' do
  action :install
end

node['nw-log-decoder']['firewall_rules'].each do |rule|
  firewall_rule rule['name'] do
    protocol rule['protocol'].downcase.to_sym
    port rule['ports']
    direction :in
    command :allow
    action :create
  end
end
