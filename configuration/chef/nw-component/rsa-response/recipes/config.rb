#
# Cookbook Name:: rsa-response 
# Recipe:: config
# Sets up im db and user in mongo
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#



execute "Add im account" do
  command "mongo admin -u #{node['mongod']['admin_account']} -p #{node['mongod']['admin_pw']} " \
          "--eval \"db.getSiblingDB('im').createUser({user: \'#{node['rsa-response']['im_account']}\', " \
          "pwd: \'#{node['rsa-response']['im_pw']}\', roles: ['readWrite']})\""
  only_if "mongo im -u \'#{node['rsa-response']['im_account']}\' -p \'#{node['rsa-response']['im_pw']}\' " \
          "--eval 'db.getUsers()' | grep 'Error: Authentication failed.'"
end