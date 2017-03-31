require_relative '../spec_helper.rb'

describe 'nw-pki::ca_stage' do
  test_comp = {
    'ca' => {
      'devmode' => 'disabled',
      'cert_pem' => '/tmp/pki/test/ca-cert.pem',
      'cert_meta' => '/tmp/pki/test/ca-cert.info'
    },
    'filesystem' => {
      'default_perms' => {
        'owner' => 'testuser',
        'group' => 'testgroup',
        'dirmode' => '0750',
        'filemode' => '0640'
      }
    },
    'ss_client' => {
      'http_fallback' => false
    }
  }

  ca_cert_pem = test_comp['ca']['cert_pem']

  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['nw-pki'] = test_comp
    end.converge(described_recipe)
  end

  it 'creates tracking/meta file' do
    expect(chef_run).to create_file(test_comp['ca']['cert_meta']).with(
      user: test_comp['filesystem']['default_perms']['owner'],
      group: test_comp['filesystem']['default_perms']['group'],
      mode: test_comp['filesystem']['default_perms']['filemode']
    )
    expect(chef_run).not_to delete_file(test_comp['ca']['cert_meta'])
    expect(chef_run).not_to touch_file(test_comp['ca']['cert_meta'])
  end

  it 'notifies ca cert removal on meta updates' do
    cert_file = chef_run.file(ca_cert_pem)
    expect(cert_file).to do_nothing

    meta_file = chef_run.file(test_comp['ca']['cert_meta'])
    expect(meta_file).to notify("file[#{ca_cert_pem}]").to(:delete).immediately
  end

  it 'calls the security server' do
    expect(chef_run).to run_execute("get-ca-cert:#{ca_cert_pem}")
  end

  it 'does not fallback to http' do
    expect(chef_run).not_to run_execute("get-ca-cert[bootstrap]:#{ca_cert_pem}")
  end

  it 'does not call devca' do
    expect(chef_run).not_to run_execute("get-ca-cert[dev]:#{ca_cert_pem}")
  end
end
