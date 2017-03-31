#
# Cookbook Name:: nw-pki
# Recipe:: keystores
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

node['nw-pki']['certificates'].each do |cert|
  unless cert['exports'].nil?
    cert['exports'].each do |export|
      perms = if export['perms']
                # use keystore-specific perms since they were specified
                export['perms']
              else
                # use default perms from the certificate configuration (if any)
                cert['perms']
              end

      # create a subscription to drop existing keystore if cert is re-generated
      file export['path'] do
        action :nothing
        subscribes :delete, "nw_pki_certificate[#{cert['cert_pem']}]", :immediately
      end

      key_entry_alias = if export['alias']
                          # use keystore-specific alias
                          export['alias']
                        else
                          # use default alias from the certificate configuration
                          cert['alias']
                        end

      nw_pki_keystore export['path'] do
        store_type export['type']
        store_path export['path']
        store_pass 'changeit'
        key_pem cert['key_pem']
        cert_pem cert['cert_pem']
        cert_alias key_entry_alias
        perms perms
        action :create
        only_if { !::File.exist?(store_path) || ::File.size(store_path).zero? }
      end

      unless export['symlinks'].nil?
        export['symlinks'].each do |symlink|
          nw_pki_symlink symlink do
            store_path export['path']
          end
        end
      end
    end
  end
end
