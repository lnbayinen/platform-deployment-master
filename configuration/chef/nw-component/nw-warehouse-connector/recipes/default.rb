#
# Cookbook Name:: nw-warehouse-connector
# Recipe:: default
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'nw-warehouse-connector::accounts'
include_recipe 'nw-warehouse-connector::packages'
include_recipe 'nw-warehouse-connector::firewall'
include_recipe 'nw-warehouse-connector::filesystem'
include_recipe 'nw-warehouse-connector::services'
include_recipe 'nw-warehouse-connector::serviceinfo'
