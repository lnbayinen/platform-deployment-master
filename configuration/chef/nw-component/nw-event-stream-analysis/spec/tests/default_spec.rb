require_relative '../spec_helper.rb'

describe 'nw-event-stream-analysis::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
    end.converge(described_recipe)
  end
end
