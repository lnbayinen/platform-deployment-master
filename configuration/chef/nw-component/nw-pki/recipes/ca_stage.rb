#
# Cookbook Name:: nw-pki
# Recipe:: ca_stage
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#
# Retrieves the CA certificate (for downstream use by the certificate
# and truststore resources).
#

# ca configuration
ca_config = node['nw-pki']['ca']

# security server client configuration
ssc_config = node['nw-pki']['ss_client']

# filesystem configuration
fs_config = node['nw-pki']['filesystem']

# lookup default perms
default_perms = fs_config['default_perms']
owner = default_perms['owner']
group = default_perms['group']
mode = default_perms['filemode']

# meta file for tracking attribute updates (to trigger ca-cert export)
file ca_config['cert_meta'] do
  content "devmode: #{ca_config['devmode']}\n" \
          "cert: #{ca_config['cert_pem']}\n"
  owner owner
  group group
  mode mode
  notifies :delete, "file[#{ca_config['cert_pem']}]", :immediately
end

file ca_config['cert_pem'] do
  action :nothing
end

# export CA cert for security server (amqp)
execute "get-ca-cert:#{ca_config['cert_pem']}" do
  ignore_failure true if ca_config['devmode'] == 'mixed' || ssc_config['http_fallback']
  command "#{node['nw-pki']['security_cli_home']}/bin/security.sh " \
          '--get-trusts ' \
          '-s security-server ' \
          "-b #{node['nw-pki']['mq_host']} " \
          "-f #{ca_config['cert_pem']} " \
          "&& chown #{owner}:#{group} #{ca_config['cert_pem']} " \
          "&& chmod #{mode} #{ca_config['cert_pem']}"
  creates ca_config['cert_pem']
  only_if { ca_config['devmode'] != 'enabled' }
end

# export CA cert for security server (http-fallback)
execute "get-ca-cert[bootstrap]:#{ca_config['cert_pem']}" do
  sensitive true
  ignore_failure true if ca_config['devmode'] == 'mixed'
  command "#{node['nw-pki']['security_cli_home']}/bin/security.sh " \
          '--get-trusts ' \
          '-s security-server ' \
          '--use-http --no-cert-check ' \
          "-u #{ssc_config['userid']} " \
          "-k #{ssc_config['password']} " \
          "-b #{node['nw-pki']['mq_host']} " \
          "-f #{ca_config['cert_pem']} " \
          "&& chown #{owner}:#{group} #{ca_config['cert_pem']} " \
          "&& chmod #{mode} #{ca_config['cert_pem']}"
  creates ca_config['cert_pem']
  only_if { ca_config['devmode'] != 'enabled' && ssc_config['http_fallback'] }
end

# export CA cert for devca (just copy dev-ca's cert)
execute "get-ca-cert[dev]:#{ca_config['cert_pem']}" do
  command "cp #{node['nw-pki']['security_cli_home']}/dev-ca/ca-cert.pem #{ca_config['cert_pem']} " \
          "&& chown #{owner}:#{group} #{ca_config['cert_pem']} " \
          "&& chmod #{mode} #{ca_config['cert_pem']}"
  creates ca_config['cert_pem']
  only_if { ca_config['devmode'] == 'mixed' || ca_config['devmode'] == 'enabled' }
end
