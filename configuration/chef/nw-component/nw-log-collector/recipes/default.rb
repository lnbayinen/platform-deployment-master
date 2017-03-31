#
# Cookbook Name:: nw-log-collector
# Recipe:: default
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'nw-log-collector::accounts'
include_recipe 'nw-log-collector::packages'
include_recipe 'nw-log-collector::selinux'
include_recipe 'nw-log-collector::rabbitmq'
include_recipe 'nw-log-collector::firewall'
include_recipe 'nw-log-collector::filesystem'
include_recipe 'nw-log-collector::services'
include_recipe 'nw-log-collector::serviceinfo'
include_recipe 'nw-log-collector::collectd'
