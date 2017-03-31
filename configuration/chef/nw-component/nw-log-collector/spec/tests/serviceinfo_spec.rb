require_relative '../spec_helper.rb'

describe 'nw-log-collector::serviceinfo' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['nw-log-collector']['component_name'] = 'component_name'
    end.converge(described_recipe)
  end

  component_name = "component_name"
  serviceinfo_directory = "/etc/netwitness/platform/nodeinfo/#{component_name}"
  serviceuuid_filepath = "#{serviceinfo_directory}/service-id"

  it 'creates the service-id file if missing' do
    expect(chef_run).to create_file_if_missing(serviceuuid_filepath)
  end

  it 'creates the serviceinfo directory' do
    expect(chef_run).to create_directory(serviceinfo_directory)
  end
end
