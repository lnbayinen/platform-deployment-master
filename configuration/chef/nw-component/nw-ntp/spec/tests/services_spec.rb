require_relative '../spec_helper.rb'

describe 'nw-ntp::services' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['nw-ntp']['service_names'] = %w(
        nw-ntp
      )
      node.normal['nw-ntp']['environment_opts'] = {
          :env_opt => 'env_test_value'
      }
    end.converge(described_recipe)
  end

  it 'starts and enables the nw-ntp service' do
    expect(chef_run).to enable_service('nw-ntp')
    expect(chef_run).to start_service('nw-ntp')
    expect(chef_run).not_to disable_service('nw-ntp')
    expect(chef_run).not_to stop_service('nw-ntp')
    expect(chef_run).not_to restart_service('nw-ntp')
    expect(chef_run).not_to reload_service('nw-ntp')
  end

  it 'creates a systemd environment drop-in file' do
    expect(chef_run).to create_systemd_service('nw-ntp-opts-managed')
  end
end
