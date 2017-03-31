#
# Cookbook Name:: rsa-esa-analytics-server
# Recipe:: default
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'rsa-esa-analytics-server::accounts'
include_recipe 'rsa-esa-analytics-server::packages'
include_recipe 'rsa-esa-analytics-server::firewall'
include_recipe 'rsa-esa-analytics-server::filesystem'
include_recipe 'rsa-esa-analytics-server::services'
include_recipe 'rsa-esa-analytics-server::serviceinfo'
include_recipe 'rsa-esa-analytics-server::config'