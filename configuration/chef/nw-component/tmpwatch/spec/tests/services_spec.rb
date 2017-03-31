require_relative '../spec_helper.rb'

describe 'tmpwatch::services' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['tmpwatch']['service_names'] = %w(
        tmpwatch
      )
      node.normal['tmpwatch']['environment_opts'] = {
          :env_opt => 'env_test_value'
      }
    end.converge(described_recipe)
  end

  it 'starts and enables the tmpwatch service' do
    expect(chef_run).to enable_service('tmpwatch')
    expect(chef_run).to start_service('tmpwatch')
    expect(chef_run).not_to disable_service('tmpwatch')
    expect(chef_run).not_to stop_service('tmpwatch')
    expect(chef_run).not_to restart_service('tmpwatch')
    expect(chef_run).not_to reload_service('tmpwatch')
  end

  it 'creates a systemd environment drop-in file' do
    expect(chef_run).to create_systemd_service('tmpwatch-opts-managed')
  end
end
