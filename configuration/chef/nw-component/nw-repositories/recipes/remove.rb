#
# Cookbook Name:: nw-repositories
# Recipe:: remove
#
# Copyright (c) 2016 RSA Security, All Rights Reserved.
#

node['nw-repositories']['repos'].each do |id, _|
  yum_repository "Remove #{id}" do
    repositoryid id
    action :delete
  end
end
