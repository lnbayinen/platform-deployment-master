require_relative '../spec_helper.rb'

describe 'nw-pki::expire' do
  test_comp = {
    'certificates' => [{
      'alias' => 'foo-server-cert',
      'subject_cn' => 'fooserver',
      'key_pem' => '/tmp/pki/test/foo-server-key.pem',
      'cert_pem' => '/tmp/pki/test/foo-server-cert.pem',
      'exports' => [
        {
          'type' => 'pkcs12',
          'path' => '/tmp/pki/test/foo-server.p12',
          'symlinks' => ['/tmp/pki/legacy/foo-server.p12']
        }
      ]
    }],
    'trust' => {
      'exports' => [{
        'type' => 'pkcs12',
        'path' => '/tmp/pki/test/foo-trusts.p12',
        'symlinks' => ['/tmp/pki/legacy/foo-trusts.p12']
      }]
    },
    'trust_peer' => {
      'cert_pem' => '/tmp/pki/test/peer-cert.pem'
    }
  }

  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['nw-pki'] = test_comp
    end.converge(described_recipe)
  end

  test_comp['certificates'].each do |cert|
    it "deletes key #{cert['key_pem']}" do
      expect(chef_run).to delete_file(cert['key_pem'])
      expect(chef_run).not_to create_file(cert['key_pem'])
      expect(chef_run).not_to touch_file(cert['key_pem'])
    end

    it "deletes cert #{cert['cert_pem']}" do
      expect(chef_run).to delete_file(cert['cert_pem'])
      expect(chef_run).not_to create_file(cert['cert_pem'])
      expect(chef_run).not_to touch_file(cert['cert_pem'])
    end

    cert['exports'].each do |export|
      it "deletes keystore #{export['path']}" do
        expect(chef_run).to delete_file(export['path'])
        expect(chef_run).not_to create_file(export['path'])
        expect(chef_run).not_to touch_file(export['path'])
      end

      export['symlinks'].each do |symlink|
        it "deletes symlink #{symlink}" do
          expect(chef_run).to delete_link(symlink)
          expect(chef_run).not_to create_link(symlink)
        end
      end
    end
  end

  test_comp['trust']['exports'].each do |trust|
    it "deletes truststore #{trust['path']}" do
      expect(chef_run).to delete_file(trust['path'])
      expect(chef_run).not_to create_file(trust['path'])
      expect(chef_run).not_to touch_file(trust['path'])
    end

    trust['symlinks'].each do |symlink|
      it "deletes symlink #{symlink}" do
        expect(chef_run).to delete_link(symlink)
        expect(chef_run).not_to create_link(symlink)
      end
    end
  end

  it "deletes trustpeer #{test_comp['trust_peer']['cert_pem']}" do
    expect(chef_run).to delete_file(test_comp['trust_peer']['cert_pem'])
    expect(chef_run).not_to create_file(test_comp['trust_peer']['cert_pem'])
    expect(chef_run).not_to touch_file(test_comp['trust_peer']['cert_pem'])
  end
end
