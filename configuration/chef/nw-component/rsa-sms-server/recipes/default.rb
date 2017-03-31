#
# Cookbook Name:: rsa-sms-server
# Recipe:: default
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'rsa-sms-server::accounts'
include_recipe 'rsa-sms-server::packages'
include_recipe 'rsa-sms-server::firewall'
include_recipe 'rsa-sms-server::filesystem'
include_recipe 'rsa-sms-server::services'
include_recipe 'rsa-sms-server::serviceinfo'
include_recipe 'rsa-sms-server::collectd'
