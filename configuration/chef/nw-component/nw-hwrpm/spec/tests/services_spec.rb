require_relative '../spec_helper.rb'

describe 'nw-hwrpm::services' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['nw-hwrpm']['service_names'] = %w(
        nw-hwrpm
      )
    end.converge(described_recipe)
  end

  it 'starts and enables the nw-hwrpm service' do
    expect(chef_run).to enable_service('nw-hwrpm')
    expect(chef_run).to start_service('nw-hwrpm')
    expect(chef_run).not_to disable_service('nw-hwrpm')
    expect(chef_run).not_to stop_service('nw-hwrpm')
    expect(chef_run).not_to restart_service('nw-hwrpm')
    expect(chef_run).not_to reload_service('nw-hwrpm')
  end
end
