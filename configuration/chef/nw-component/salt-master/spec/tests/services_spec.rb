require_relative '../spec_helper.rb'

describe 'salt-master::services' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['salt-master']['service_names'] = %w(
        salt-master
      )
      node.normal['salt-master']['environment_opts'] = {
          :env_opt => 'env_test_value'
      }
    end.converge(described_recipe)
  end

  it 'starts and enables the salt-master service' do
    expect(chef_run).to enable_service('salt-master')
    expect(chef_run).to start_service('salt-master')
    expect(chef_run).not_to disable_service('salt-master')
    expect(chef_run).not_to stop_service('salt-master')
    expect(chef_run).not_to restart_service('salt-master')
    expect(chef_run).not_to reload_service('salt-master')
  end

  it 'creates a systemd environment drop-in file' do
    expect(chef_run).to create_systemd_service('salt-master-opts-managed')
  end
end
