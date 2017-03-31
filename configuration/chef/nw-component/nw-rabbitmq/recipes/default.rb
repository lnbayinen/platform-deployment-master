#
# Cookbook Name:: nw-rabbitmq
# Recipe:: default
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'nw-rabbitmq::accounts'
include_recipe 'nw-rabbitmq::groups'
include_recipe 'nw-rabbitmq::packages'
include_recipe 'nw-rabbitmq::firewall'
include_recipe 'nw-rabbitmq::filesystem'
include_recipe 'nw-rabbitmq::services'
include_recipe 'nw-rabbitmq::serviceinfo'
include_recipe 'nw-rabbitmq::config'
include_recipe 'nw-rabbitmq::plugins'
include_recipe 'nw-rabbitmq::vhosts'
include_recipe 'nw-rabbitmq::users'
include_recipe 'nw-rabbitmq::policies'
