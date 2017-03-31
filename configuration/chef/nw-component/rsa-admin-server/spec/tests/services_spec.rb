require_relative '../spec_helper.rb'

describe 'rsa-admin-server::services' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['rsa-admin-server']['service_names'] = %w(
        rsa-admin-server
      )
      node.normal['rsa-admin-server']['environment_opts'] = {
          :env_opt => 'env_test_value'
      }
    end.converge(described_recipe)
  end

  it 'starts and enables the rsa-admin-server service' do
    expect(chef_run).to enable_service('rsa-admin-server')
    expect(chef_run).to start_service('rsa-admin-server')
    expect(chef_run).not_to disable_service('rsa-admin-server')
    expect(chef_run).not_to stop_service('rsa-admin-server')
    expect(chef_run).not_to restart_service('rsa-admin-server')
    expect(chef_run).not_to reload_service('rsa-admin-server')
  end

  it 'creates a systemd environment drop-in file' do
    expect(chef_run).to create_systemd_service('rsa-admin-server-opts-managed')
  end
end
