require_relative '../spec_helper.rb'

describe 'rsa-contexthub::serviceinfo' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['rsa-contexthub']['component_name'] = 'component_name'
    end.converge(described_recipe)
  end

  component_name = "component_name"
  serviceinfo_directory = "/etc/netwitness/platform/nodeinfo/#{component_name}"
  serviceuuid_filepath = "#{serviceinfo_directory}/service-id"

  it 'creates the service-id file' do
    expect(chef_run).to create_file(serviceuuid_filepath)
  end

  it 'creates the serviceinfo directory' do
    expect(chef_run).to create_directory(serviceinfo_directory)
  end
end
