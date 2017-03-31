#
# Cookbook Name:: nw-pki
# Recipe:: expire
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#
# Removes all cert and keystore artifacts based on the current descriptor.
#

node['nw-pki']['certificates'].each do |cert|
  cert_folder = ::File.dirname(cert['cert_pem'])
  cert_name = ::File.basename(cert['cert_pem'], '.*')

  file cert['key_pem'] do
    action :delete
  end

  file cert['cert_pem'] do
    action :delete
  end

  file "#{cert_folder}/#{cert_name}.p7b" do
    action :delete
  end

  unless cert['exports'].nil?
    cert['exports'].each do |export|
      file export['path'] do
        action :delete
      end

      unless export['symlinks'].nil?
        export['symlinks'].each do |symlink|
          link symlink do
            action :delete
          end
        end
      end
    end
  end
end

node['nw-pki']['trust']['exports'].each do |export|
  file export['path'] do
    action :delete
  end

  unless export['symlinks'].nil?
    export['symlinks'].each do |symlink|
      link symlink do
        action :delete
      end
    end
  end
end

file node['nw-pki']['trust_peer']['cert_pem'] do
  action :delete
end
