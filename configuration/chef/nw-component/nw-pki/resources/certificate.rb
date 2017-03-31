#
# Cookbook Name:: nw-pki
# Resource:: certificate
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#
# Generates a key-pair, submits CSR, and creates certificate from CSR response.
#

property :key_pem, String, required: true
property :cert_pem, String, name_property: true
property :cert_alias, String, required: true
property :subject_cn, String, required: true
property :perms, Hash, required: false

default_action :create

action :create do
  # CA configuration
  ca_config = node['nw-pki']['ca']

  # security server client configuration
  ssc_config = node['nw-pki']['ss_client']

  key_folder = ::File.dirname(key_pem)
  key_name = ::File.basename(key_pem, '.*')
  csr_path = "#{key_folder}/#{key_name}.csr"

  cert_folder = ::File.dirname(cert_pem)
  cert_name = ::File.basename(cert_pem, '.*')
  chain_path = "#{cert_folder}/#{cert_name}.p7b"

  directory key_folder do
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

  # generate new key
  execute "key-pair:#{key_pem}" do
    sensitive true
    command 'openssl genrsa ' \
            "-out #{key_pem} #{node['nw-pki']['key_size']} " \
            "&& chown #{owner}:#{group} #{key_pem} " \
            "&& chmod #{mode} #{key_pem}"
    not_if { ::File.exist?(key_pem) }
  end

  # generate CSR request
  execute "request:#{csr_path}" do
    command 'openssl req ' \
            '-new ' \
            "-subj '#{node['nw-pki']['dn_base']}/CN=#{subject_cn}' " \
            "-key #{key_pem} " \
            "-out #{csr_path}"
    not_if { ::File.exist?(cert_pem) }
  end

  # send CSR to security server (amqp)
  # TODO: executing "--ping ... && false" as a place-holder (security server CSR API not yet available)
  execute "issue:#{cert_pem}" do
    ignore_failure true if ca_config['devmode'] == 'mixed' || ssc_config['http_fallback']
    command "#{node['nw-pki']['security_cli_home']}/bin/security.sh " \
            '--ping ' \
            "-b #{node['nw-pki']['mq_host']} && false " \
            "&& rm -f #{csr_path} " \
            "&& chown #{owner}:#{group} #{cert_pem} " \
            "&& chmod #{mode} #{cert_pem}"
    only_if { ::File.exist?(csr_path) && ca_config['devmode'] != 'enabled' }
  end

  # send CSR to security server (http-fallback)
  # TODO: executing "--ping ... && false" as a place-holder (security server CSR API not yet available)
  execute "issue[bootstrap]:#{cert_pem}" do
    sensitive true
    ignore_failure true if ca_config['devmode'] == 'mixed'
    command "#{node['nw-pki']['security_cli_home']}/bin/security.sh " \
            '--ping ' \
            '--use-http --no-cert-check ' \
            "-u #{ssc_config['userid']} " \
            "-k #{ssc_config['password']} " \
            "-b #{node['nw-pki']['mq_host']} && false " \
            "&& rm -f #{csr_path} " \
            "&& chown #{owner}:#{group} #{cert_pem} " \
            "&& chmod #{mode} #{cert_pem}"
    only_if { ::File.exist?(csr_path) && ca_config['devmode'] != 'enabled' && ssc_config['http_fallback'] }
  end

  # process CSR with dev-ca (dev-fallback)
  execute "issue[dev]:#{cert_pem}" do
    command 'openssl x509 ' \
            '-req ' \
            "-CA #{ca_config['cert_pem']} " \
            "-CAkey #{node['nw-pki']['security_cli_home']}/dev-ca/ca.pem " \
            "-in #{csr_path} " \
            "-out #{cert_pem} " \
            '-days 365 ' \
            '-CAcreateserial ' \
            "&& rm -f #{csr_path} " \
            "&& chown #{owner}:#{group} #{cert_pem} " \
            "&& chmod #{mode} #{cert_pem}"
    only_if { ::File.exist?(csr_path) && (ca_config['devmode'] == 'mixed' || ca_config['devmode'] == 'enabled') }
  end

  # create pkcs7 cert chain
  execute "chain:#{chain_path}" do
    command 'openssl crl2pkcs7 ' \
            '-nocrl ' \
            "-certfile #{cert_pem} " \
            "-certfile #{ca_config['cert_pem']} " \
            "-out #{chain_path} " \
            "&& chown #{owner}:#{group} #{chain_path} " \
            "&& chmod #{mode} #{chain_path}"
    not_if { ::File.exist?(chain_path) }
  end
end
