#
# Cookbook Name:: nw-repositories
# Recipe:: cleanup
#
# Copyright (c) 2016 RSA Security, All Rights Reserved.
#

# Remove existing default repositories
node['nw-repositories']['remove-repos'].each do |reponame|
  yum_repository "Remove #{reponame} repository" do
    repositoryid reponame
    action :delete
  end
end
