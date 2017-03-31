#
# Cookbook Name:: rsa-audit
# Recipe:: default
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'rsa-audit::accounts'
include_recipe 'rsa-audit::packages'
include_recipe 'rsa-audit::firewall'
include_recipe 'rsa-audit::filesystem'
include_recipe 'rsa-audit::services'
include_recipe 'rsa-audit::config'
