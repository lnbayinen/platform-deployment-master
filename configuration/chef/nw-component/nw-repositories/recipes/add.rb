#
# Cookbook Name:: nw-repositories
# Recipe:: add
#
# Copyright (c) 2016 RSA Security, All Rights Reserved.
#

node['nw-repositories']['repos'].each do |id, repo|

  baseurl = (id =='rsanw' && node['global'] && node['global']['yum-repo-url']) ?
      node['global']['yum-repo-url'] : repo[:baseurl]

  yum_repository "Add #{id}" do
    repositoryid id
    description repo[:name]
    baseurl baseurl
    enabled repo[:enabled] if repo.key?(:enabled)
    gpgcheck repo[:gpgcheck] if repo.key?(:gpgcheck)
    exclude repo[:excludes].join(' ') if repo.key?(:excludes)
    cost repo[:cost] if repo.key?(:cost)
    sslverify repo[:sslverify] if repo.key?(:sslverify)
    sensitive true
    action :create
    # the special 'snapshot' repo should only be processed if enabled
    only_if { id != 'snapshot' || repo[:enabled] }
  end
end
