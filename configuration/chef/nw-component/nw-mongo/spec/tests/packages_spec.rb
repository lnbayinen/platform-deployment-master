require_relative '../spec_helper.rb'

describe 'nw-mongo::packages' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['nw-mongo']['packages'] = [{
        'name' => 'nw-mongo',
        'version' => '11.0.0.0'
      }]
    end.converge(described_recipe)
  end

  it 'installs the nw-mongo package to version 11.0.0.0' do
    expect(chef_run).to install_package('nw-mongo').with(version: '11.0.0.0')
    expect(chef_run).not_to remove_package('nw-mongo')
    expect(chef_run).not_to reconfig_package('nw-mongo')
    expect(chef_run).not_to upgrade_package('nw-mongo')
  end
end
