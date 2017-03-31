#
# Cookbook Name:: rsa-orchestration-server
# Recipe:: default
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'rsa-orchestration-server::accounts'
include_recipe 'rsa-orchestration-server::packages'
include_recipe 'rsa-orchestration-server::firewall'
include_recipe 'rsa-orchestration-server::filesystem'
include_recipe 'rsa-orchestration-server::config'
include_recipe 'rsa-orchestration-server::services'
include_recipe 'rsa-orchestration-server::serviceinfo'
