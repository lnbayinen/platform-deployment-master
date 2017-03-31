require_relative '../spec_helper.rb'

describe 'nw-pki::services' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['nw-pki']['service_names'] = %w(
        nw-pki
      )
      node.normal['nw-pki']['environment_opts'] = {
          :env_opt => 'env_test_value'
      }
    end.converge(described_recipe)
  end

  it 'starts and enables the nw-pki service' do
    expect(chef_run).to enable_service('nw-pki')
    expect(chef_run).to start_service('nw-pki')
    expect(chef_run).not_to disable_service('nw-pki')
    expect(chef_run).not_to stop_service('nw-pki')
    expect(chef_run).not_to restart_service('nw-pki')
    expect(chef_run).not_to reload_service('nw-pki')
  end

  it 'creates a systemd environment drop-in file' do
    expect(chef_run).to create_systemd_service('nw-pki-opts-managed')
  end
end
