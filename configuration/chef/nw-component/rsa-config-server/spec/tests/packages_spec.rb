require_relative '../spec_helper.rb'

describe 'rsa-config-server::packages' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['rsa-config-server']['packages'] = [{
        'name' => 'rsa-config-server',
        'version' => '11.0.0.0'
      }]
    end.converge(described_recipe)
  end

  pkgs = {
    'rsa-config-server' => '11.0.0.0'
  }

  pkgs.each do |name, ver|
    it "installs the #{name} package to version #{ver}" do
      expect(chef_run).to install_package(name).with(version: ver)
      expect(chef_run).not_to remove_package(name)
      expect(chef_run).not_to reconfig_package(name)
      expect(chef_run).not_to upgrade_package(name)
    end
  end
end
