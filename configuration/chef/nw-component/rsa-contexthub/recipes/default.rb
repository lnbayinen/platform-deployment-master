#
# Cookbook Name:: rsa-contexthub
# Recipe:: default
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'rsa-contexthub::accounts'
include_recipe 'rsa-contexthub::packages'
include_recipe 'rsa-contexthub::firewall'
include_recipe 'rsa-contexthub::filesystem'
include_recipe 'rsa-contexthub::services'
include_recipe 'rsa-contexthub::serviceinfo'
