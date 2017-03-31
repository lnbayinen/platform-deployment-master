#
# Cookbook Name:: nw-pki
# Resource:: keystore
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#
# Creates a keystore from the given key/certificate pair.
#
# Supported keystore types:
#
# - pkcs12: P12 keystore
# - jks: JKS keystore
# - key-pem: key-only base64 PEM
# - cert-pem: cert-only base64 PEM
# - pair-pem: key+cert base64 PEM
#

property :store_type, String, required: true
property :store_path, String, name_property: true
property :store_pass, String, required: true
property :key_pem, String, required: true
property :cert_pem, String, required: true
property :cert_alias, String, required: true
property :perms, Hash, required: false

default_action :create

action :delete do
  if ::File.exist?(store_path)
    ::File.delete(store_path)
  end
end

action :create do
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

  cert_folder = ::File.dirname(cert_pem)
  cert_name = ::File.basename(cert_pem, '.*')
  chain_path = "#{cert_folder}/#{cert_name}.p7b"
  cert_chain_temp = "/tmp/openssl-ca-chain.#{::SecureRandom.uuid}"

  case store_type
  when 'pkcs12', 'jks'

    # create P12 (since it's also a prerequisite for creating JKS)
    stage_store = "#{store_path}-p12-stage"
    if store_type == 'pkcs12'
      # just use p12 path (since we are only creating p12)
      store_path_p12 = store_path
    else
      # use a stage path (since we are creating p12 for conversion to JKS)
      store_path_p12 = stage_store
    end

    if ::File.exist?(chain_path)
      # pkcs7 chain available, export chain
      cert_chain_stage = cert_chain_temp
      execute "chain:#{store_path_p12}" do
        command 'openssl pkcs7 ' \
                '-print_certs ' \
                "-in #{chain_path} " \
                "-out #{cert_chain_temp}"
      end
    else
      # pkcs7 chain not available, use standalone cert
      cert_chain_stage = cert_pem
    end

    # create P12
    execute "export:#{store_path_p12}" do
      sensitive true
      command 'openssl pkcs12 ' \
              '-export ' \
              "-passout pass:#{store_pass} " \
              "-name #{cert_alias} " \
              "-in #{cert_chain_stage} " \
              "-inkey #{key_pem} " \
              "-out #{store_path_p12} " \
              "&& rm -f #{cert_chain_temp} " \
              "&& chown #{owner}:#{group} #{store_path_p12} " \
              "&& chmod #{mode} #{store_path_p12}"
    end

    # create JKS
    if store_type == 'jks'
      execute "export:#{store_path}" do
        sensitive true
        command 'keytool -importkeystore ' \
                "-alias #{cert_alias} " \
                "-srckeystore #{stage_store} " \
                '-srcstoretype PKCS12 ' \
                "-srcstorepass #{store_pass} " \
                "-deststorepass #{store_pass} " \
                "-destkeypass #{store_pass} " \
                "-destkeystore #{store_path} " \
                "&& rm -f #{stage_store} " \
                "&& chown #{owner}:#{group} #{store_path} " \
                "&& chmod #{mode} #{store_path}"
      end
    end

  when 'key-pem'
    # copy key PEM
    file store_path do
      sensitive true
      content lazy { ::File.open(key_pem).read }
      owner owner
      group group
      mode mode
      action :create
    end

  when 'cert-pem'
    # copy cert PEM
    file store_path do
      content lazy { ::File.open(cert_pem).read }
      owner owner
      group group
      mode mode
      action :create
    end

  when 'pair-pem'
    # create a PEM that contains both key and cert
    file store_path do
      sensitive true
      content lazy { ::File.open(cert_pem).read + ::File.open(key_pem).read }
      owner owner
      group group
      mode mode
      action :create
    end
  end
end
