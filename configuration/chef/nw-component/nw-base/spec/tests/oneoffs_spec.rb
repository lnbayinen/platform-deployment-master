require_relative '../spec_helper.rb'

describe 'nw-base::oneoffs' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
    end.converge(described_recipe)
  end

  it 'restarts rsyslogd to fix the hostname in OpenStack' do
    expect(chef_run).to restart_service('Fix hostname in rsyslog')
  end
end
