require_relative '../spec_helper.rb'

describe 'nw-pki::keystores' do
  test_comp = {
    'certificates' => [{
      'alias' => 'foo-server-cert',
      'subject_cn' => 'fooserver',
      'key_pem' => '/tmp/pki/test/foo-server-key.pem',
      'cert_pem' => '/tmp/pki/test/foo-server-cert.pem',
      'exports' => [
        {
          'type' => 'jks',
          'path' => '/tmp/pki/test/foo-server.jks',
          'symlinks' => ['/tmp/pki/legacy/foo-server.jks']
        },
        {
          'type' => 'pkcs12',
          'path' => '/tmp/pki/test/foo-server.p12',
          'symlinks' => ['/tmp/pki/legacy/foo-server.p12']
        },
        {
          'type' => 'cert-pem',
          'path' => '/tmp/pki/test/foo-server.cer',
          'symlinks' => ['/tmp/pki/legacy/foo-server.cer']
        },
        {
          'type' => 'key-pem',
          'path' => '/tmp/pki/test/foo-server.key',
          'symlinks' => ['/tmp/pki/legacy/foo-server.key']
        },
        {
          'type' => 'pair-pem',
          'path' => '/tmp/pki/test/foo-server.pem',
          'symlinks' => ['/tmp/pki/legacy/foo-server.pem']
        }
      ]
    }]
  }

  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['nw-pki'] = test_comp
    end.converge(described_recipe)
  end

  test_comp['certificates'].each do |cert|
    cert['exports'].each do |export|
      it "creates keystore #{cert['alias']}:#{export['type']}" do
        expect(chef_run).to create_nw_pki_keystore(export['path']).with(
          store_type: export['type'],
          store_path: export['path'],
          key_pem: cert['key_pem'],
          cert_pem: cert['cert_pem'],
          cert_alias: cert['alias']
        )
      end

      it "does nothing with file #{export['path']}" do
        expect(chef_run).not_to delete_file(export['path'])
        expect(chef_run).not_to create_file(export['path'])
        expect(chef_run).not_to touch_file(export['path'])
      end

      export['symlinks'].each do |symlink|
        it "creates symlink #{symlink}" do
          expect(chef_run).to create_nw_pki_symlink(symlink).with(
            store_path: export['path']
          )
        end
      end
    end
  end
end
