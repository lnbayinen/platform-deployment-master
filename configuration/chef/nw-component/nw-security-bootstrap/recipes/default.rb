#
# Cookbook Name:: nw-security-bootstrap
# Recipe:: default
#
# Copyright (C) 2016 RSA Security
#
# All rights reserved - Do Not Redistribute
#
# This cookbook includes recipes from the nw-pki, nw-rabbitmq, and nw-mongo cookbooks.
# The ruby_block will check, at runtime, whether or not we need to bootstrap the security server
# and run the other service cookbooks.

include_recipe 'nw-repositories::default'

include_recipe 'nw-security-bootstrap::accounts'
include_recipe 'nw-security-bootstrap::groups'
include_recipe 'nw-security-bootstrap::packages'
include_recipe 'nw-security-bootstrap::firewall'

ruby_block 'Checking if Security Server bootstrap is required' do
  block do
    def amqp_available?()
      Chef::Log.info 'Running security client to ping Security Server via AMQP.'
      cmd = "/opt/rsa/platform/nw-security-cli/bin/security.sh --ping"
      cmd = Mixlib::ShellOut.new(cmd)
      cmd.run_command
      begin
        cmd.error!
        Chef::Log.info 'Successfully connected to Security Server via AMQP.'
        true
      rescue
        Chef::Log.info 'Failed to connect to Security Server via AMQP.'
        false
      end
    end

    lockbox_exists = ::File.exist?('/etc/netwitness/security-server/lockbox.ss')
    Chef::Log.info("Security Server lockbox exists? #{lockbox_exists}")

    # if the lockbox doesn't exist or amqp is not available via security client, include all recipes
    if ! lockbox_exists || ! amqp_available?
      run_context.include_recipe 'nw-security-bootstrap::bootstrap'

      run_context.include_recipe 'nw-pki::default'
      run_context.include_recipe 'nw-rabbitmq::default'
      run_context.include_recipe 'nw-mongo::default'

      run_context.include_recipe 'nw-security-bootstrap::cleanup'
    end
  end
end