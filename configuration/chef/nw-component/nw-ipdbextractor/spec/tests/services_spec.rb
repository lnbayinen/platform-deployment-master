require_relative '../spec_helper.rb'

describe 'nw-ipdbextractor::services' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['nw-ipdbextractor']['service_names'] = %w(
        nw-ipdbextractor
      )
      node.normal['nw-ipdbextractor']['environment_opts'] = {
          :env_opt => 'env_test_value'
      }
    end.converge(described_recipe)
  end

  it 'starts and enables the nw-ipdbextractor service' do
    expect(chef_run).to enable_service('nw-ipdbextractor')
    expect(chef_run).to start_service('nw-ipdbextractor')
    expect(chef_run).not_to disable_service('nw-ipdbextractor')
    expect(chef_run).not_to stop_service('nw-ipdbextractor')
    expect(chef_run).not_to restart_service('nw-ipdbextractor')
    expect(chef_run).not_to reload_service('nw-ipdbextractor')
  end

  it 'creates a systemd environment drop-in file' do
    expect(chef_run).to create_systemd_service('nw-ipdbextractor-opts-managed')
  end
end
