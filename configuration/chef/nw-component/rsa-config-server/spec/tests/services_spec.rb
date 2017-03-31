require_relative '../spec_helper.rb'

describe 'rsa-config-server::services' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['rsa-config-server']['service_names'] = %w(
        rsa-config-server
      )
      node.normal['rsa-config-server']['environment_opts'] = {
          :env_opt => 'env_test_value'
      }
    end.converge(described_recipe)
  end

  it 'starts and enables the rsa-config-server service' do
    expect(chef_run).to enable_service('rsa-config-server')
    expect(chef_run).to start_service('rsa-config-server')
    expect(chef_run).not_to disable_service('rsa-config-server')
    expect(chef_run).not_to stop_service('rsa-config-server')
    expect(chef_run).not_to restart_service('rsa-config-server')
    expect(chef_run).not_to reload_service('rsa-config-server')
  end

  it 'creates a systemd environment drop-in file' do
    expect(chef_run).to create_systemd_service('rsa-config-server-opts-managed')
  end
end
