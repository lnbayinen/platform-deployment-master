require_relative '../spec_helper.rb'

describe 'nw-workbench::services' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['nw-workbench']['service_names'] = %w(
        nw-workbench
      )
      node.normal['nw-workbench']['environment_opts'] = {
          :env_opt => 'env_test_value'
      }
    end.converge(described_recipe)
  end

  it 'starts and enables the nw-workbench service' do
    expect(chef_run).to enable_service('nw-workbench')
    expect(chef_run).to start_service('nw-workbench')
    expect(chef_run).not_to disable_service('nw-workbench')
    expect(chef_run).not_to stop_service('nw-workbench')
    expect(chef_run).not_to restart_service('nw-workbench')
    expect(chef_run).not_to reload_service('nw-workbench')
  end

  it 'creates a systemd environment drop-in file' do
    expect(chef_run).to create_systemd_service('nw-workbench-opts-managed')
  end
end
