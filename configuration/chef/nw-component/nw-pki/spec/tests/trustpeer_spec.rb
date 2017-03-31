require_relative '../spec_helper.rb'

describe 'nw-pki::trustpeer' do
  test_comp = {
    'ca' => {
      'devmode' => 'disabled',
      'cert_pem' => '/tmp/pki/test/ca-cert.pem',
      'cert_meta' => '/tmp/pki/test/ca-cert.info'
    },
    'trust_peer' => {
      'cert_pem' => '/tmp/pki/test/peer-cert.pem'
    },
    'certificates' => [{
      'alias' => 'foo-server-cert',
      'subject_cn' => 'fooserver',
      'key_pem' => '/tmp/pki/test/foo-server-key.pem',
      'cert_pem' => '/tmp/pki/test/foo-server-cert.pem',
      'node_common' => true
    }],
    'filesystem' => {
      'default_perms' => {
        'owner' => 'testuser',
        'group' => 'testgroup',
        'dirmode' => '0750',
        'filemode' => '0640'
      }
    }
  }

  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['nw-pki'] = test_comp
    end.converge(described_recipe)
  end

  host_check_command = 'grep -e "127.0.0.1.*[ ]nw-node-zero" /etc/hosts > /dev/null 2>&1'

  it 'retrieve the peer cert if on node-x' do
    stub_command(host_check_command).and_return(false)
    expect(chef_run).to run_execute('retrieve-peer-cert')
  end

  it 'does not retrieve the peer cert if on node-zero' do
    stub_command(host_check_command).and_return(true)
    expect(chef_run).not_to run_execute('retrieve-peer-cert')
  end

  it 'does not create peer file if on node-x' do
    stub_command(host_check_command).and_return(false)
    expect(chef_run).not_to create_file(test_comp['trust_peer']['cert_pem'])
    expect(chef_run).not_to delete_file(test_comp['trust_peer']['cert_pem'])
    expect(chef_run).not_to touch_file(test_comp['trust_peer']['cert_pem'])
  end

  it 'creates peer file if on node-zero' do
    stub_command(host_check_command).and_return(true)
    expect(chef_run).to create_file(test_comp['trust_peer']['cert_pem']).with(
      user: test_comp['filesystem']['default_perms']['owner'],
      group: test_comp['filesystem']['default_perms']['group'],
      mode: test_comp['filesystem']['default_perms']['filemode']
    )
    expect(chef_run).not_to delete_file(test_comp['trust_peer']['cert_pem'])
    expect(chef_run).not_to touch_file(test_comp['trust_peer']['cert_pem'])
  end
end
