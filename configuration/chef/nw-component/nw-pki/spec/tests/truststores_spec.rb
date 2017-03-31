require_relative '../spec_helper.rb'

describe 'nw-pki::truststores' do
  test_comp = {
    'trust' => {
      'exports' => [
        {
          'type' => 'jks',
          'path' => '/tmp/pki/test/foo-server-trust.jks',
          'symlinks' => ['/tmp/pki/legacy/foo-server-trust.jks']
        },
        {
          'type' => 'pkcs12',
          'path' => '/tmp/pki/test/foo-server-trust.p12',
          'symlinks' => ['/tmp/pki/legacy/foo-server-trust.p12']
        },
        {
          'type' => 'pem',
          'path' => '/tmp/pki/test/foo-server-trust.cer',
          'symlinks' => ['/tmp/pki/legacy/foo-server-trust.cer']
        }
      ]
    }
  }

  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['nw-pki'] = test_comp
    end.converge(described_recipe)
  end

  test_comp['trust']['exports'].each do |trust|
    it "creates truststore #{trust['path']}" do
      expect(chef_run).to create_nw_pki_truststore(trust['path']).with(
        store_type: trust['type'],
        store_path: trust['path']
      )
    end

    trust['symlinks'].each do |symlink|
      it "creates symlink #{symlink}" do
        expect(chef_run).to create_nw_pki_symlink(symlink).with(
          store_path: trust['path']
        )
      end
    end
  end
end
