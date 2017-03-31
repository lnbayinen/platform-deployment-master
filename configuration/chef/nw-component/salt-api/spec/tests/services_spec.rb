require_relative '../spec_helper.rb'

describe 'salt-api::services' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['salt-api']['service_names'] = %w(
        salt-api
      )
      node.normal['salt-api']['environment_opts'] = {
          :env_opt => 'env_test_value'
      }
    end.converge(described_recipe)
  end

  it 'starts and enables the salt-api service' do
    expect(chef_run).to enable_service('salt-api')
    expect(chef_run).to start_service('salt-api')
    expect(chef_run).not_to disable_service('salt-api')
    expect(chef_run).not_to stop_service('salt-api')
    expect(chef_run).not_to restart_service('salt-api')
    expect(chef_run).not_to reload_service('salt-api')
  end

  it 'creates a systemd environment drop-in file' do
    expect(chef_run).to create_systemd_service('salt-api-opts-managed')
  end
end
