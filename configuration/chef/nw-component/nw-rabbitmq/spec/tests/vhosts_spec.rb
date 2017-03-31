require_relative '../spec_helper.rb'

describe 'nw-rabbitmq::vhosts' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['nw-rabbitmq']['vhosts'] = %w(/foo/bar)
    end.converge(described_recipe)
  end

  vhosts = %w(/foo/bar)

  vhosts.each do |vhost|
    it "adds the #{vhost} vhost" do
      expect(chef_run).to add_nw_rabbitmq_vhost(vhost)
      expect(chef_run).not_to delete_nw_rabbitmq_vhost(vhost)
    end
  end
end
