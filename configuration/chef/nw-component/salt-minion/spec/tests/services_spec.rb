require_relative '../spec_helper.rb'

describe 'salt-minion::services' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['salt-minion']['service_names'] = %w(
        salt-minion
      )
      node.normal['salt-minion']['environment_opts'] = {
          :env_opt => 'env_test_value'
      }
    end.converge(described_recipe)
  end

  it 'starts and enables the salt-minion service' do
    expect(chef_run).to enable_service('salt-minion')
    expect(chef_run).to start_service('salt-minion')
    expect(chef_run).not_to disable_service('salt-minion')
    expect(chef_run).not_to stop_service('salt-minion')
    expect(chef_run).not_to restart_service('salt-minion')
    expect(chef_run).not_to reload_service('salt-minion')
  end

  it 'creates a systemd environment drop-in file' do
    expect(chef_run).to create_systemd_service('salt-minion-opts-managed')
  end
end
