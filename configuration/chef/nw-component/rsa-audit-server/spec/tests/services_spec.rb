require_relative '../spec_helper.rb'

describe 'rsa-audit-server::services' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['rsa-audit-server']['service_names'] = %w(
        rsa-audit-server
      )
      node.normal['rsa-audit-server']['environment_opts'] = {
          :env_opt => 'env_test_value'
      }
    end.converge(described_recipe)
  end

  it 'starts and enables the rsa-audit-server service' do
    expect(chef_run).to enable_service('rsa-audit-server')
    expect(chef_run).to start_service('rsa-audit-server')
    expect(chef_run).not_to disable_service('rsa-audit-server')
    expect(chef_run).not_to stop_service('rsa-audit-server')
    expect(chef_run).not_to restart_service('rsa-audit-server')
    expect(chef_run).not_to reload_service('rsa-audit-server')
  end

  it 'creates a systemd environment drop-in file' do
    expect(chef_run).to create_systemd_service('rsa-audit-server-opts-managed')
  end
end
