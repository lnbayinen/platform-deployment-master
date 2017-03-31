require_relative '../spec_helper.rb'

describe 'nw-rabbitmq::policies' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['nw-rabbitmq']['policies'] = [{
        'name' => 'expiry',
        'pattern' => '.*',
        'params' => {
          'expires' => '864000000'
        },
        'vhost' => '/rsa/system',
        'apply_to' => 'queues'
      }]
    end.converge(described_recipe)
  end

  it 'sets the expiry policy' do
    expect(chef_run).to set_nw_rabbitmq_policy('expiry')
    expect(chef_run).not_to clear_nw_rabbitmq_policy('expiry')
    expect(chef_run).not_to list_nw_rabbitmq_policy
  end
end
