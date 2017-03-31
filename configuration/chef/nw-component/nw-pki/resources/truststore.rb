#
# Cookbook Name:: nw-pki
# Resource:: truststore
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#
# Creates a truststore from the given certificate.
#
# Supported truststore types:
#
# - pkcs12: P12 keystore
# - jks: JKS keystore
# - pem: cert-only base64 PEM
#

property :store_type, String, required: true
property :store_path, String, name_property: true
property :store_pass, String, required: true
property :perms, Hash, required: false

default_action :create

action :delete do
  if ::File.exist?(store_path)
    ::File.delete(store_path)
  end
end

action :create do
  ca_config = node['nw-pki']['ca']
  store_folder = ::File.dirname(store_path)

  directory store_folder do
    recursive true
    action :create
  end

  if perms.nil?
    # use default strict permissions
    owner = node['nw-pki']['default_strict_owner']
    group = node['nw-pki']['default_strict_group']
    mode = node['nw-pki']['default_strict_mode']
  else
    owner = perms['owner']
    group = perms['group']
    mode = perms['mode']
  end

  case store_type
  when 'jks'
    # create JKS based truststore file
    execute "export:#{store_path}" do
      sensitive true
      command 'keytool -import ' \
              '-noprompt ' \
              '-alias nw-ca ' \
              "-file #{ca_config['cert_pem']} " \
              "-keystore #{store_path} " \
              "-storepass #{store_pass} " \
              "&& chown #{owner}:#{group} #{store_path} " \
              "&& chmod #{mode} #{store_path}"
    end

  when 'pkcs12'
    # create pkcs12 based truststore
    execute "export:#{store_path}" do
      sensitive true
      command 'openssl pkcs12 ' \
            '-export ' \
            '-nokeys ' \
            '-name nw_ca ' \
            "-in #{ca_config['cert_pem']} " \
            "-out #{store_path} " \
            "-passout pass:#{store_pass} " \
            "&& chown #{owner}:#{group} #{store_path} " \
            "&& chmod #{mode} #{store_path}"
    end

  when 'pem'
    # create pem based truststore file
    file store_path do
      content lazy { ::File.open(ca_config['cert_pem']).read }
      owner owner
      group group
      mode mode
      action :create
    end

  end
end
