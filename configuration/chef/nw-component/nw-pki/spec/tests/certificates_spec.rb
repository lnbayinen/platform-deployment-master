require_relative '../spec_helper.rb'

describe 'nw-pki::certificates' do
  test_comp = {
    'certificates' => [{
      'alias' => 'foo-server-cert',
      'subject_cn' => 'fooserver',
      'key_pem' => '/tmp/pki/test/foo-server-key.pem',
      'cert_pem' => '/tmp/pki/test/foo-server-cert.pem'
    }],
    'ss_client' => {
      'http_fallback' => false
    }
  }

  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['nw-pki'] = test_comp
    end.converge(described_recipe)
  end

  test_comp['certificates'].each do |cert|
    it "creates certificate #{cert['alias']}" do
      expect(chef_run).to create_nw_pki_certificate(cert['cert_pem']).with(
        key_pem: cert['key_pem'],
        cert_pem: cert['cert_pem'],
        cert_alias: cert['alias'],
        subject_cn: cert['subject_cn']
      )
    end
  end
end
