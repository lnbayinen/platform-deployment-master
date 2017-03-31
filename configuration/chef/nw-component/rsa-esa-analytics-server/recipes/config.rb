#
# Cookbook Name:: rsa-esa-analytics-server 
# Recipe:: config
# Sets up esa db and users
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#


execute "Add esa account" do
  command "mongo admin -u #{node['mongod']['admin_account']} -p #{node['mongod']['admin_pw']} " \
          "--eval \"db.getSiblingDB('esa').createUser({user: \'#{node['rsa-esa-analytics-server']['esa_account']}\', " \
          "pwd: \'#{node['rsa-esa-analytics-server']['esa_pw']}\', roles: ['readWrite', 'dbAdmin']})\""
  only_if "mongo esa -u \'#{node['rsa-esa-analytics-server']['esa_account']}\' -p \'#{node['rsa-esa-analytics-server']['esa_pw']}\' " \
          "--eval 'db.getUsers()' | grep 'Error: Authentication failed.'"
end

execute "Add esa_query account" do
  command "mongo admin -u #{node['mongod']['admin_account']} -p #{node['mongod']['admin_pw']} " \
          "--eval \"db.getSiblingDB('esa').createUser({user: \'#{node['rsa-esa-analytics-server']['esa_query_account']}\', " \
          "pwd: \'#{node['rsa-esa-analytics-server']['esa_query_pw']}\', roles: ['read']})\""
  only_if "mongo esa -u \'#{node['rsa-esa-analytics-server']['esa_query_account']}\' -p \'#{node['rsa-esa-analytics-server']['esa_query_pw']}\' " \
          "--eval 'db.getUsers()' | grep 'Error: Authentication failed.'"
end