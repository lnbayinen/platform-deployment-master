require_relative '../spec_helper.rb'

describe 'rsa-esa-analytics-server::services' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['rsa-esa-analytics-server']['service_names'] = %w(
        rsa-esa-analytics-server
      )
      node.normal['rsa-esa-analytics-server']['environment_opts'] = {
          :env_opt => 'env_test_value'
      }
    end.converge(described_recipe)
  end

  it 'starts and enables the rsa-esa-analytics-server service' do
    expect(chef_run).to enable_service('rsa-esa-analytics-server')
    expect(chef_run).to start_service('rsa-esa-analytics-server')
    expect(chef_run).not_to disable_service('rsa-esa-analytics-server')
    expect(chef_run).not_to stop_service('rsa-esa-analytics-server')
    expect(chef_run).not_to restart_service('rsa-esa-analytics-server')
    expect(chef_run).not_to reload_service('rsa-esa-analytics-server')
  end

  it 'creates a systemd environment drop-in file' do
    expect(chef_run).to create_systemd_service('rsa-esa-analytics-server-opts-managed')
  end
end
