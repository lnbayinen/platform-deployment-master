require_relative '../spec_helper.rb'

describe 'nw-base::collectd' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.automatic['hostname'] = 'testing'
    end.converge(described_recipe)
  end

  dir = '/usr/lib/collectd/python/comp_modules'
  it 'creates the comp_modules directory for collectd' do
    expect(chef_run).to create_directory(dir)
  end

  config = '/etc/collectd.conf'
  it 'creates the base collectd configuration file' do
    expect(chef_run).to render_file(config).with_content { |content|
      expect(content).to match(/Hostname\s+"testing"/)
    }
  end
end
