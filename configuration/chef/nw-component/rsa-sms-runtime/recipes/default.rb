#
# Cookbook Name:: rsa-sms-runtime
# Recipe:: default
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'rsa-sms-runtime::accounts'
include_recipe 'rsa-sms-runtime::groups'
include_recipe 'rsa-sms-runtime::packages'
include_recipe 'rsa-sms-runtime::firewall'
include_recipe 'rsa-sms-runtime::filesystem'
include_recipe 'rsa-sms-runtime::services'
include_recipe 'rsa-sms-runtime::federation'
include_recipe 'rsa-sms-runtime::collectd'
