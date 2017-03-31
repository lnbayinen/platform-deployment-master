require_relative '../spec_helper.rb'

describe 'rsa-config-server::firewall' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['rsa-config-server']['firewall_rules'] = [{
        'protocol' => 'tcp',
        'ports' => [80, 443],
        'name' => 'unit test ports'
      }]
    end.converge(described_recipe)
  end

  it 'enables the firewall' do
    expect(chef_run).to install_firewall('default')
    expect(chef_run).not_to disable_firewall('default')
  end

  it 'adds a firewall rule' do
    expect(chef_run).to create_firewall_rule('unit test ports')
  end
end
