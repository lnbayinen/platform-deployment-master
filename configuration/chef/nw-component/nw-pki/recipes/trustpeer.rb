#
# Cookbook Name:: nw-pki
# Recipe:: trustpeer
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#
# Retrieves the node-zero/admin server certificate for trustpeer
# configuration.
#
# NOTE: node-zero certificate currently being retrieved via openssl
# call to rabbitmq SSL port.  This is a temporary workaround until
# the Security Server API is updated to support node certificate
# retrieval.  Openssl call should be replaced with a call to the
# Security Server once it supports certificate retrievals.
#

# ca configuration
ca_config = node['nw-pki']['ca']

# trustpeer configuration
peer_config = node['nw-pki']['trust_peer']

# filesystem configuration
fs_config = node['nw-pki']['filesystem']

# lookup default perms
default_perms = fs_config['default_perms']
owner = default_perms['owner']
group = default_perms['group']
mode = default_perms['filemode']

# lookup the node certificate
common_cert = node['nw-pki']['certificates'].select do |c|
  c.key?('node_common') && c['node_common']
end.first

# for node-x: download node-zero cert (see note above)
execute 'retrieve-peer-cert' do
  command 'openssl s_client ' \
          "-connect #{node['nw-pki']['mq_host']}:5671 " \
          "-CAfile #{ca_config['cert_pem']} " \
          '| openssl x509 -outform PEM ' \
          '| sed -n "/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p" ' \
          "> #{peer_config['cert_pem']} " \
          '&& test ${PIPESTATUS[1]} -eq 0 ' \
          "&& chown #{owner}:#{group} #{peer_config['cert_pem']} " \
          "&& chmod #{mode} #{peer_config['cert_pem']} " \
          "|| ( rm -f #{peer_config['cert_pem']} && false )"
  creates peer_config['cert_pem']
  not_if 'grep -e "127.0.0.1.*[ ]nw-node-zero" /etc/hosts > /dev/null 2>&1'
end

# for node-zero: copy the local node/common cert
file peer_config['cert_pem'] do
  content lazy { ::File.open(common_cert['cert_pem']).read }
  owner owner
  group group
  mode mode
  action :create
  only_if 'grep -e "127.0.0.1.*[ ]nw-node-zero" /etc/hosts > /dev/null 2>&1'
end
