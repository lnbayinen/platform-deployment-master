#
# Cookbook Name:: rsa-sms-runtime
# Recipe:: federation
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#

upstream_uri = format(
  'amqps://%s:%d',
  node['ipaddress'],
  node['nw-rabbitmq']['amqps_port']
)
upstream_name = "carlos-upstream-#{node['global']['host']['id']}"

nw_rabbitmq_federation upstream_name do
  host node['nw-rabbitmq']['node_zero']
  port node['nw-rabbitmq']['mgmt_port']
  vhost '/rsa/system'
  ca_file node['nw-pki']['ca']['cert_pem']
  policy_name 'carlos-federate'
  uri upstream_uri
  pattern '^carlos\\.*'
  apply_to 'exchanges'
  expires 3_600_000
  action :create
  # FIXME: use a run-time assigned node attribute to differentiate
  not_if { node.run_list.include?('recipe[salt-master]') }
end
