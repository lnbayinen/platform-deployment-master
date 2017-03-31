require_relative '../spec_helper.rb'

describe 'nw-log-collector::selinux' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
    end.converge(described_recipe)
  end

  it 'deploys an selinux policy module for nw-collectd' do
    expect(chef_run).to deploy_selinux_policy_module('nw-collectd')
  end

  it 'deploys an selinux policy module for nw-rabbitmq' do
    expect(chef_run).to deploy_selinux_policy_module('nw-rabbitmq')
  end

  it 'deploys an selinux policy module for nw-syslog' do
    expect(chef_run).to deploy_selinux_policy_module('nw-syslog')
  end

  it 'sets an selinux boolean for collectd_tcp_network_connect' do
    expect(chef_run).to setpersist_selinux_policy_boolean('collectd_tcp_network_connect')
  end
end
