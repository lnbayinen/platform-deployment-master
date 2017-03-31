require_relative '../spec_helper.rb'

describe 'rsa-sms-runtime::federation' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.automatic['ipaddress'] = '1.2.3.4'
      node.normal['nw-rabbitmq']['amqps_port'] = 5671
      node.normal['nw-rabbitmq']['node_zero'] = '5.6.7.8'
      node.normal['nw-rabbitmq']['mgmt_port'] = 15_671
      node.normal['global']['host']['id'] = 'foo-bar-frobaz-quux'
      node.normal['nw-pki']['ca']['cert_pem'] = '/not-really'
    end.converge(described_recipe)
  end

  name = 'carlos-upstream-foo-bar-frobaz-quux'

  it 'federates this broker to node zero' do
    expect(chef_run).to create_nw_rabbitmq_federation(name).with(
      host: '5.6.7.8',
      port: 15_671,
      uri: 'amqps://1.2.3.4:5671',
      pattern: '^carlos\\.*',
      apply_to: 'exchanges'
    )
  end
end
