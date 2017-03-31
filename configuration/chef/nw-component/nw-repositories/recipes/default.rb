#
# Cookbook Name:: nw-repositories
# Recipe:: default
#
# Copyright (c) 2016 RSA Security, All Rights Reserved.
#

include_recipe 'nw-repositories::cleanup'
include_recipe 'nw-repositories::addkeys'
include_recipe 'nw-repositories::add'
