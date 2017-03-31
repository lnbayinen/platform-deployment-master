# Cookbook Name:: nw-mongo 
# Recipe:: config
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#


execute "validate mongo is up" do
  command "mongo  --eval 'db.show'"
  retries 5
  retry_delay 5
end

execute "Add admin account" do
  command "mongo admin --eval \"db.createUser({user: \'#{node['mongod']['admin_account']}\', " \
          "pwd: \'#{node['mongod']['admin_pw']}\', roles: ['readWriteAnyDatabase', 'userAdminAnyDatabase', 'dbAdminAnyDatabase']})\""
  only_if "mongo admin -u \'#{node['mongod']['admin_account']}\' -p \'#{node['mongod']['admin_pw']}\' " \
          "--eval 'db.getUsers()' | grep 'Error: Authentication failed.'"
end
