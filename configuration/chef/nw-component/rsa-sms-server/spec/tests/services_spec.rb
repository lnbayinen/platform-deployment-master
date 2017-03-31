require_relative '../spec_helper.rb'

describe 'rsa-sms-server::services' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['rsa-sms-server']['service_names'] = %w(
        rsa-sms-server
      )
      node.normal['rsa-sms-server']['environment_opts'] = {
          :env_opt => 'env_test_value'
      }
    end.converge(described_recipe)
  end

  it 'starts and enables the rsa-sms-server service' do
    expect(chef_run).to enable_service('rsa-sms-server')
    expect(chef_run).to start_service('rsa-sms-server')
    expect(chef_run).not_to disable_service('rsa-sms-server')
    expect(chef_run).not_to stop_service('rsa-sms-server')
    expect(chef_run).not_to restart_service('rsa-sms-server')
    expect(chef_run).not_to reload_service('rsa-sms-server')
  end

  it 'creates a systemd environment drop-in file' do
    expect(chef_run).to create_systemd_service('rsa-sms-server-opts-managed')
  end
end
