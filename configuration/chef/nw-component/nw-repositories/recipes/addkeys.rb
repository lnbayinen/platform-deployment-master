#
# Cookbook Name:: nw-repositories
# Recipe:: addkeys
#
# Copyright (c) 2016 RSA Security, All Rights Reserved.
#

node['nw-repositories']['keys'].each do |key|
  key_path = ::File.join('/etc/pki/rpm-gpg', key)

  cookbook_file key_path do
    source "keys/#{key}"
    owner 'root'
    group 'root'
    mode '0644'
    notifies :run, "execute[add RPM GPG key #{key}]", :immediately
  end

  execute "add RPM GPG key #{key}" do
    command "rpm --import #{key_path}"
    action :nothing
  end
end
