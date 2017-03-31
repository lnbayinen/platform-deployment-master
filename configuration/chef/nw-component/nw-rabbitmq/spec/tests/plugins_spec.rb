require_relative '../spec_helper.rb'

describe 'nw-rabbitmq::plugins' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['nw-rabbitmq']['plugins'] = %w(example)
    end.converge(described_recipe)
  end

  plugins = %w(example)

  plugins.each do |plugin|
    it "enables the #{plugin} plugin" do
      expect(chef_run).to enable_nw_rabbitmq_plugin(plugin)
      expect(chef_run).not_to disable_nw_rabbitmq_plugin(plugin)
    end
  end
end
