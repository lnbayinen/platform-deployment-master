require_relative '../spec_helper.rb'

describe 'nw-archiver::services' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['nw-archiver']['service_names'] = %w(
        nw-archiver
      )
      node.normal['nw-archiver']['environment_opts'] = {
          :env_opt => 'env_test_value'
      }
    end.converge(described_recipe)
  end

  it 'starts and enables the nw-archiver service' do
    expect(chef_run).to enable_service('nw-archiver')
    expect(chef_run).to start_service('nw-archiver')
    expect(chef_run).not_to disable_service('nw-archiver')
    expect(chef_run).not_to stop_service('nw-archiver')
    expect(chef_run).not_to restart_service('nw-archiver')
    expect(chef_run).not_to reload_service('nw-archiver')
  end

  it 'creates a systemd environment drop-in file' do
    expect(chef_run).to create_systemd_service('nw-archiver-opts-managed')
  end
end
