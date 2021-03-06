require_relative '../spec_helper.rb'

describe 'nw-concentrator::services' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['nw-concentrator']['service_names'] = %w(
        nw-concentrator
      )
      node.normal['nw-concentrator']['environment_opts'] = {
          :env_opt => 'env_test_value'
      }
    end.converge(described_recipe)
  end

  it 'starts and enables the nw-concentrator service' do
    expect(chef_run).to enable_service('nw-concentrator')
    expect(chef_run).to start_service('nw-concentrator')
    expect(chef_run).not_to disable_service('nw-concentrator')
    expect(chef_run).not_to stop_service('nw-concentrator')
    expect(chef_run).not_to restart_service('nw-concentrator')
    expect(chef_run).not_to reload_service('nw-concentrator')
  end

  it 'creates a systemd environment drop-in file' do
    expect(chef_run).to create_systemd_service('nw-concentrator-opts-managed')
  end
end
