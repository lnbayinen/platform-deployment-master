require_relative '../spec_helper.rb'

describe 'nw-base::packages' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
    end.converge(described_recipe)
  end

  package_list = [
    { 'name' => 'java-1.8.0-openjdk', 'version' => '1:1.8.0.101-3.b13.el7_2' },
    { 'name' => 'rsa-carlos', 'version' => '11.0.0.0' },
    { 'name' => 'rsa-collectd', 'version' => '11.0.0.0' },
    { 'name' => 'rsa-sms-runtime-rt', 'version' => '11.0.0.0' }
  ]

  package_list.each do |pkg|
    package = pkg['name']
    version = pkg['version']
    it "installs the #{package} package to version #{version}" do
      expect(chef_run).to install_package(package).with(version: version)
      expect(chef_run).not_to remove_package(package)
      expect(chef_run).not_to reconfig_package(package)
      expect(chef_run).not_to upgrade_package(package)
    end
  end
end
