#
# Cookbook Name:: nw-pki
# Recipe:: truststores
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

trust = node['nw-pki']['trust']

unless trust['exports'].nil?
  trust['exports'].each do |truststore|
    perms = if truststore['perms']
              # use truststore-specific perms since they were specified
              truststore['perms']
            else
              # use default perms from the trust configuration (if any)
              trust['perms']
            end

    nw_pki_truststore truststore['path'] do
      store_type truststore['type']
      store_path truststore['path']
      store_pass 'changeit'
      perms perms
      action :create
      only_if { !::File.exist?(store_path) || ::File.size(store_path).zero? }
    end

    unless truststore['symlinks'].nil?
      truststore['symlinks'].each do |symlink|
        nw_pki_symlink symlink do
          store_path truststore['path']
        end
      end
    end
  end
end
