#
# Cookbook Name:: rsa-response
# Recipe:: default
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'rsa-response::accounts'
include_recipe 'rsa-response::packages'
include_recipe 'rsa-response::firewall'
include_recipe 'rsa-response::filesystem'
include_recipe 'rsa-response::services'
include_recipe 'rsa-response::serviceinfo'
include_recipe 'rsa-response::config'
