require_relative '../spec_helper.rb'

describe 'rsa-security-server::services' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['rsa-security-server']['service_names'] = %w(
        rsa-security-server
      )
      node.normal['rsa-security-server']['environment_opts'] = {
          :env_opt => 'env_test_value'
      }
    end.converge(described_recipe)
  end

  it 'starts and enables the rsa-security-server service' do
    expect(chef_run).to enable_service('rsa-security-server')
    expect(chef_run).to start_service('rsa-security-server')
    expect(chef_run).not_to disable_service('rsa-security-server')
    expect(chef_run).not_to stop_service('rsa-security-server')
    expect(chef_run).not_to restart_service('rsa-security-server')
    expect(chef_run).not_to reload_service('rsa-security-server')
  end

  it 'creates a systemd environment drop-in file' do
    expect(chef_run).to create_systemd_service('rsa-security-server-opts-managed')
  end
end
