#
# Cookbook Name:: rsa-investigate
# Recipe:: default
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'rsa-investigate::accounts'
include_recipe 'rsa-investigate::packages'
include_recipe 'rsa-investigate::firewall'
include_recipe 'rsa-investigate::filesystem'
include_recipe 'rsa-investigate::services'
include_recipe 'rsa-investigate::serviceinfo'
