#
# Cookbook Name:: nw-pki
# Recipe:: default
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'nw-pki::accounts'
include_recipe 'nw-pki::groups'
include_recipe 'nw-pki::packages'
include_recipe 'nw-pki::firewall'
include_recipe 'nw-pki::filesystem'
include_recipe 'nw-pki::services'
include_recipe 'nw-pki::ca_stage'
include_recipe 'nw-pki::certificates'
include_recipe 'nw-pki::keystores'
include_recipe 'nw-pki::truststores'
include_recipe 'nw-pki::trustpeer'
