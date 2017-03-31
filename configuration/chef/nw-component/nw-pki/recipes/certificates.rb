#
# Cookbook Name:: nw-pki
# Recipe:: certificates
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

node['nw-pki']['certificates'].each do |cert|
  nw_pki_certificate cert['cert_pem'] do
    key_pem cert['key_pem']
    cert_pem cert['cert_pem']
    cert_alias cert['alias']
    subject_cn cert['subject_cn']
    perms cert['perms']
    action :create
    not_if { ::File.exist?(cert['key_pem']) && ::File.exist?(cert['cert_pem']) }
  end
end
